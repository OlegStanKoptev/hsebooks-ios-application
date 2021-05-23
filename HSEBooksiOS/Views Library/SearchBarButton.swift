//
//  SearchBarButton.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 19.05.2021.
//

import SwiftUI

struct SearchBarButton: View {
    @ObservedObject var appContext = AppContext.shared
    var placeholderText = "Search books, authors"
    var body: some View {
        Button(action: { appContext.searchIsPresented = true }) {
            HStack {
                Text(placeholderText)
                    .foregroundColor(.init(.systemGray2))
                    .padding(.vertical, 1)
                Spacer()
            }
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(4)
                .padding(.horizontal, 16)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 24)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SearchBarButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarButton()
    }
}
