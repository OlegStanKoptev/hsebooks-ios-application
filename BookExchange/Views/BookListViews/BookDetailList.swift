//
//  BookDetailList.swift
//  BookExchange
//
//  Created by Oleg Koptev on 21.01.2021.
//

import SwiftUI

struct BookDetailList: View {
    var header: String
    @Binding var books: [BookBase_deprecated]
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar()
                .padding(.vertical, 4)
            NavBar(header: header)
            Spacer(minLength: 0)
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 6)
                    ForEach(books) { book in
                        BookDetailListItem(book: book)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .backgroundForNavBar(height: 44 + 36)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
    }
}

struct BookDetailList_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailList(header: "header", books: .constant([
            BookBase_deprecated(id: 1, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase_deprecated(id: 2, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase_deprecated(id: 3, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase_deprecated(id: 4, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase_deprecated(id: 5, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0)
        ]))
    }
}
