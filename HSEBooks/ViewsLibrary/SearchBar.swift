//
//  SearchBar.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct SearchBar: View {
    var placeholderText = "Search books, authors"
    @Binding var query: String
    var onCommit: (() -> Void)?
    @State private var isEditing = false
    var body: some View {
        HStack(spacing: 0) {
            TextField(placeholderText, text: $query) { isEditing in
                withAnimation {
                    self.isEditing = isEditing
                }
            } onCommit: { onCommit?() }
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(4)
                .padding(.horizontal, 10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 18)
                        Button(action: { query = "" }, label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 18)
                        })
                        .opacity(!query.isEmpty ? 1 : 0)
                    }
                )
            if isEditing || !query.isEmpty {
                Button(action: {
                    withAnimation {
                        isEditing = false
                        query = ""
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.orange)
                })
                .padding(.trailing, 16)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(.vertical, 4)
        .onDisappear {
            query = ""
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(query: .constant(""))
            .background(Color("SecondColor"))
            .previewLayout(.sizeThatFits)
    }
}
