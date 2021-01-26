//
//  BookListContent.swift
//  BookExchange
//
//  Created by Oleg Koptev on 25.01.2021.
//

import SwiftUI

struct BookListContent: View {
    var localBooks: [BookBase]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                Ad()
                BookListSection(header: "Local books", books: localBooks)
                BookListLoadableSection(header: "Books from server")
                Color.clear.frame(height: 100)
            }
        }
    }
}

struct BookListContent_Previews: PreviewProvider {
    static var previews: some View {
        BookListContent(localBooks: [])
    }
}
