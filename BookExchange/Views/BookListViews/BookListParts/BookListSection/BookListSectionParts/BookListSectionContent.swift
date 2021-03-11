//
//  BookListSectionContent.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct BookListSectionContent: View {
    @Binding var books: [BookBase_deprecated]
    var placeholderImage: Bool = false
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Color.clear.frame(width: 0)
                ForEach(books) { book in
                    BookListItem(author: book.author, title: book.title, rating: book.rating, city: book.language, pictureUrl: !placeholderImage ? book.pictureUrl : nil)
                }
                Color.clear.frame(width: 2)
            }
            .padding(.vertical, 4)
        }
    }
}

struct BookListSectionContent_Previews: PreviewProvider {
    static var previews: some View {
        BookListSectionContent(books: .constant([BookBase_deprecated(id: 1, author: "test", language: "eng", title: "title", numberOfPages: 1, publishYear: 1, wishers: [1], genres: [1], rating: 5.0)]))
    }
}
