//
//  HomePage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var authData: AuthData
    @StateObject var viewModel = HomePageViewModel()
    @State var query: String = ""
    
    func fetchData() {
        viewModel.fetch(with: authData)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(viewModel.sections, id: \.0.name) { row in
                    VStack(spacing: 6) {
                        NavigationLink(destination: Text("123")) {
                            HStack(spacing: 6) {
                                Text(row.0.name)
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize - 2))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                        HStack {
                            ForEach(row.1) { book in
                                NavigationLink(destination: Text(book.title)) {
                                    Color.quaternaryColor
                                        .aspectRatio(2 / 3, contentMode: .fill)
                                        .overlay(Text(book.title).padding())
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .overlay(
                StatusOverlay(viewState: $viewModel.viewState)
            )
            .onChange(of: authData.isLoggedIn) { _ in
                fetchData()
            }
            .onAppear {
                fetchData()
            }
            .navigationTitle(BookBase.home.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextField("Search bar...", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width - 32)
                        .padding(.bottom, 12)
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(AuthData.preview)
    }
}
