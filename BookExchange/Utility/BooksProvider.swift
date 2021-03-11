//
//  BooksProvider.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.01.2021.
//

import Foundation

class BooksProvider: ObservableObject {
    var loader: BooksLoading = BooksLoader()
    @Published var books: [BookBase_deprecated] = []
    @Published var loading: Bool = false
    func load() {
        loading = true
        loader.load {
            self.books = $0
            self.loading = false
        }
    }
}
