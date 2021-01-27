//
//  BookDetailList.swift
//  BookExchange
//
//  Created by Oleg Koptev on 21.01.2021.
//

import SwiftUI

struct BookDetailList: View {
    @State var searchText: String = ""
    var header: String
    @Binding var books: [BookBase]
    
    var body: some View {
        VStack {
            NavBar(header: header)
            Spacer(minLength: 0)
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 6)
                    ForEach(books) { book in
                        BookDetailListitem(book: book)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .ignoresSafeArea(.keyboard)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SearchBar(searchText: $searchText)
            }
        }
    }
}

struct BookDetailList_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailList(header: "header", books: .constant([
            BookBase(id: 1, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase(id: 2, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase(id: 3, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase(id: 4, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0),
            BookBase(id: 5, author: "Author", language: "ENG", title: "Title here", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0)
        ]))
    }
}
