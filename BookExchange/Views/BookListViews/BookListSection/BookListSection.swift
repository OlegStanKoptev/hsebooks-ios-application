//
//  BookListSection.swift
//  BookExchange
//
//  Created by Oleg Koptev on 20.01.2021.
//

import SwiftUI

struct BookListSection: View {
    var header: String = "Default header"
    var books: [BookListItem] = [
        BookListItem(city: "City 1"),
        BookListItem(city: "City 2"),
        BookListItem(city: "City 3")
    ]
    
    var body: some View {
        VStack(spacing: 4) {
            BookListSectionHeader(header: header)
            BookListSectionContent(books: books)
        }
    }
}

struct BookListSection_Previews: PreviewProvider {
    static var previews: some View {
        BookListSection()
    }
}
