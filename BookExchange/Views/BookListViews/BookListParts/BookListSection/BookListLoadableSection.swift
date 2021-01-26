//
//  BookListLoadableSection.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct BookListLoadableSection: View {
    @EnvironmentObject var context: AppContext
    var header: String = "Default header"
    var books: [BookBase] = [
        BookBase(id: 1, author: "Author", language: "ENG", title: "Title", numberOfPages: 1, publishYear: 1, wishers: [], genres: [], rating: 5.0)
    ]

    var body: some View {
        VStack(spacing: 4) {
            BookListSectionHeader(header: header)
            Group {
                if (context.booksProvider.loading) {
                    ZStack {
                        BookListItem()
                            .hidden()
                        ProgressView(value: 0.5)
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                } else {
                    BookListSectionContent(books: $context.booksProvider.books)
                }
            }
        }
    }
}

struct BookListLoadableSection_Previews: PreviewProvider {
    static var previews: some View {
        BookListLoadableSection()
    }
}
