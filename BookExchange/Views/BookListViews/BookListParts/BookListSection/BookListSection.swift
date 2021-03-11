//
//  BookListSection.swift
//  BookExchange
//
//  Created by Oleg Koptev on 20.01.2021.
//

import SwiftUI

struct BookListSection: View {
    var header: String = "Default header"
    @State var books: [BookBase_deprecated] = [
        BookBase_deprecated(id: 1, author: "Author", language: "eng", title: "Title", numberOfPages: 1, publishYear: 1, wishers: [], genres: [], rating: 5.0),
        BookBase_deprecated(id: 2, author: "Author", language: "eng", title: "Title", numberOfPages: 1, publishYear: 1, wishers: [], genres: [], rating: 5.0)
    ]
    
    var body: some View {
        VStack(spacing: 4) {
            BookListSectionHeader(header: header, books: $books)
            BookListSectionContent(books: $books, placeholderImage: true)
        }
    }
}

struct BookListSection_Previews: PreviewProvider {
    static var previews: some View {
        BookListSection()
    }
}
