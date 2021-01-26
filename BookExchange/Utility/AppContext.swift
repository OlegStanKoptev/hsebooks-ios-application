//
//  Context.swift
//  BookExchange
//
//  Created by Oleg Koptev on 22.01.2021.
//

import Combine

class AppContext: ObservableObject {
    @Published var booksProvider: BooksProvider = BooksProvider()
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = Publishers.CombineLatest(booksProvider.$books, booksProvider.$loading).sink(receiveValue: {_ in
            self.objectWillChange.send()
        })
        booksProvider.loader = MockBooksLoader()
    }
}
