//
//  BookListLoadableSection.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct BookListLoadableSection: View {
    var header: String = "Default header"
    var books: [BookListItem] = [
        BookListItem(city: "City 1"),
        BookListItem(city: "City 2"),
        BookListItem(city: "City 3")
    ]
    
    @Binding var serverBooksLoading: Bool
    var body: some View {
        VStack(spacing: 4) {
            BookListSectionHeader(header: header)
            Group {
                if (serverBooksLoading) {
                    ZStack {
                        BookListItem()
                            .hidden()
                        ProgressView(value: 0.5)
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                } else {
                    BookListSectionContent(books: books)
                }
            }
        }
    }
}

struct BookListLoadableSection_Previews: PreviewProvider {
    static var previews: some View {
        BookListLoadableSection(serverBooksLoading: .constant(false))
    }
}
