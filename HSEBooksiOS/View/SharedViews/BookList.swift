//
//  BookList.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct BookList: View {
    @EnvironmentObject var authData: AuthData
    @StateObject var model = BooksListViewModel()
    let credentials: RemoteDataCredentials
    
    private func fetch() {
        model.fetch(with: credentials, and: authData)
    }
    
    var body: some View {
        List {
            ForEach(model.books) { book in
                NavigationLink(destination: Text(book.title)) {
                    HStack {
                        Text(String(book.photoId ?? 0))
                        VStack(alignment: .leading) {
                            Text(book.title)
                            Text(book.author)
                        }
                        Text(String(book.rating))
                    }
                }
                .onAppear {
                    if book == model.books.last! {
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
            BookList(model: .preview, credentials: Genre.genreCredentials(for: 41, title: "Some Genre"))
                .environmentObject(AuthData.preview)
        }
    }
}
