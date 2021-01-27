//
//  SearchBar.swift
//  BookExchange
//
//  Created by Oleg Koptev on 25.01.2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 16 * 2, height: 38)
            .shadow(radius: 4)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for books, authors", text: $searchText)
                        .font(.body)
                    if (searchText != "") {
                        Button(action: { searchText = "" }, label: {
                            Image(systemName: "xmark.circle.fill")
                        })
                    }
                }
                .padding(.horizontal, 8)
                .foregroundColor(.gray)
            )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
    }
}
