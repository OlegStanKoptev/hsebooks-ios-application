//
//  BookListSectionContent.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct BookListSectionContent: View {
    let books: [BookListItem]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Color.clear.frame(width: 0)
                ForEach(books) { book in
                    book
                }
                Color.clear.frame(width: 2)
            }
            .padding(.vertical, 4)
        }
    }
}

struct BookListSectionContent_Previews: PreviewProvider {
    static var previews: some View {
        BookListSectionContent(books: [ BookListItem(), BookListItem() ])
    }
}
