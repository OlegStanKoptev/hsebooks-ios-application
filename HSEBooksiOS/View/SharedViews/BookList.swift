//
//  BookList.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct BookList: View {
    let credentials: RemoteDataCredentials? = nil
    
    private func fetch() {
//        model.fetch(from: credentials, with: appState)
    }
    
    var body: some View {
        List {
            ForEach(0..<5) { index in
                Text("\(index)")
            }
//            ForEach(model.items) { book in
//                NavigationLink(destination: Text(book.title)) {
//                    Text(String(book.photoId ?? 0))
//                    VStack(alignment: .leading) {
//                        Text(book.title)
//                        Text(book.author)
//                    }
//                    Text(String(book.rating))
//                }
//                .onAppear {
//                    if book == model.items.last! {
//                        fetch()
//                    }
//                }
//            }
            
//            if model.viewState == .loading {
//                HStack {
//                    Spacer()
//                    ProgressView()
//                    Spacer()
//                }
//            }
        }
        .onAppear { fetch() }
        .navigationTitle(credentials?.name ?? "Title not stated")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookList()
        }
    }
}
