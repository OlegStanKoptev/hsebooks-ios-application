//
//  BookListSectionHeader.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct BookListSectionHeader: View {
    let header: String
    @Binding var books: [BookBase_deprecated]
    var body: some View {
        NavigationLink(destination: BookDetailList(header: header, books: $books)) {
            HStack {
                Text(header)
                    .font(.system(size: 14))
                    .textCase(.uppercase)
                    .foregroundColor(.orange)
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.top, 12)
        }
    }
}

struct BookListSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        BookListSectionHeader(header: "Default header", books: .constant([]))
    }
}
