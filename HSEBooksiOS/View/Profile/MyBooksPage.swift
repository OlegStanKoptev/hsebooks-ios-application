//
//  MyBooksPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 05.05.2021.
//

import SwiftUI

struct MyBooksPage: View {
    @EnvironmentObject var appState: AppState
    @StateObject var model: PreloadedDataViewModel<Book> = RealPreloadedDataViewModel()
    
    func fetch() {
        model.fetch(appState.authData.currentUser?.exchangeListIds, from: Book.book, with: appState)
    }
    
    var body: some View {
        List(model.items) { book in
            NavigationLink(destination: Text("book")) {
                Text("row")
//                Text(String(book.photoId ?? 0))
//                VStack(alignment: .leading) {
//                    Text(book.title)
//                    Text(book.author)
//                }
//                Text(String(book.rating))
            }
        }
        .overlay(
            StatusOverlay(viewState: $model.viewState)
        )
        .onAppear { fetch() }
        .navigationTitle("My Books")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MyBooksPage_Previews: PreviewProvider {
    static var previews: some View {
        MyBooksPage(model: MockPreloadedDataViewModel())
            .environmentObject(AppState.preview)
    }
}
