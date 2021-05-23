//
//  SearchBar.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 17.05.2021.
//

import SwiftUI

//struct SearchBar: View {
//    @Binding var query: String
//    @State private var isEditing: Bool = false
//    var body: some View {
//        HStack(spacing: 0) {
//            TextField("Search bar...", text: .constant("")) { isEditing in
//                self.isEditing = isEditing
//            } onCommit: {
//                print("Commit")
//            }
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding(.horizontal)
//
//            if !query.isEmpty || isEditing {
//                Button("Cancel", action: {
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                })
//                    .padding(.leading, -4)
//                    .padding(.trailing)
//            }
//        }
//    }
//}
//
//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(query: .constant(""))
//            .padding(.vertical)
//            .background(Color.tertiaryColor)
//            .previewLayout(.sizeThatFits)
//    }
//}

struct SearchBar: View {
    var placeholderText = "Search books, authors"
    @Binding var query: String
    var onCommit: (() -> Void)?
    var onCancel: (() -> Void)?
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
                .padding(.horizontal, 16)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 24)
                        Button(action: { query = "" }, label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 24)
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
                    onCancel?()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.orange)
                })
                .padding(.trailing, 16)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
//        .frame(width: UIScreen.main.bounds.width)
//        .onDisappear {
//            query = ""
//        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var query: String = "Initial Value"
    static var previews: some View {
        SearchBar(query: $query)
            .background(Color.tertiaryColor)
            .previewLayout(.sizeThatFits)
    }
}
