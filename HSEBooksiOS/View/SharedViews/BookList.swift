//
//  BookList.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct BookList: View {
    @EnvironmentObject var appState: AppState
    @StateObject var model: DynamicDataViewModel<BookBase> = RealDynamicDataViewModel()
    let credentials: RemoteDataCredentials
    
    private func fetch() {
        model.fetch(from: credentials, with: appState)
    }
    
    var body: some View {
        List {
            ForEach(model.items) { book in
                NavigationLink(destination: Text(book.title)) {
                    Text(String(book.photoId ?? 0))
                    VStack(alignment: .leading) {
                        Text(book.title)
                        Text(book.author)
                    }
                    Text(String(book.rating))
                }
                .onAppear {
                    if book == model.items.last! {
                        fetch()
                    }
                }
            }
            
            if model.viewState == .loading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .onAppear { fetch() }
        .navigationTitle(credentials.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookList(credentials: Genre.genreCredentials(for: 41, title: "Some Genre"))
                .environmentObject(AppState.preview)
        }
    }
}
