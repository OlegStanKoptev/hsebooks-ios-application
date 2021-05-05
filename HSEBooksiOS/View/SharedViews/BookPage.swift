//
//  BookPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import SwiftUI

struct BookPage: View {
    @EnvironmentObject var appState: AppState
    let book: BookBase
    @State var requestPresented = true
    var body: some View {
        VStack(spacing: 12) {
            if let photoId = book.photoId {
                Text("\(photoId)")
            } else {
                Text("nil")
            }
            Text(book.title)
            Text(book.author)
            Button(action: { requestPresented = true }, label: {
                Text("Request")
            })
            if let description = book.description {
                Text(description)
            }
        }
        .sheet(isPresented: $requestPresented, content: {
            RequestPage(presented: $requestPresented)
        })
        .padding()
    }
}

struct RequestPage: View {
    @Binding var presented: Bool
    var body: some View {
        NavigationView {
            List {
                Text("Placeholder")
            }
            .navigationTitle("Request")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: { presented = false }) {
                Text("Cancel")
            })
        }
    }
}

struct BookPage_Previews: PreviewProvider {
    static var previews: some View {
        BookPage(book: BookBase.getItems(amount: 1).first!)
            .environmentObject(AppState.preview)
    }
}
