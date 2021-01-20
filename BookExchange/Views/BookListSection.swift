//
//  BookListSection.swift
//  BookExchange
//
//  Created by Oleg Koptev on 20.01.2021.
//

import SwiftUI

struct BookListSection: View {
    var header: String = "Default header"
    
    var body: some View {
        VStack {
            HStack {
                Text(header)
                    .textCase(.uppercase)
                    .foregroundColor(.orange)
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.leading, 24)
            .padding(.top, 12)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    Color.clear.frame(width: 2)
                    BookListIcon(city: "City 1")
                    BookListIcon(city: "City 2")
                    BookListIcon(city: "City 3")
                    BookListIcon(city: "City 4")
                    Color.clear.frame(width: 2)
                }
                .padding(.bottom, 8)
            }
        }
    }
}

struct BookListSection_Previews: PreviewProvider {
    static var previews: some View {
        BookListSection()
    }
}
