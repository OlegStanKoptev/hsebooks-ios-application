//
//  Context.swift
//  BookExchange
//
//  Created by Oleg Koptev on 22.01.2021.
//

import Combine
import SwiftUI

class AppContext: ObservableObject {
    @Published var booksProvider: BooksProvider = BooksProvider()
    let decoder = JSONDecoder()
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = Publishers.CombineLatest(booksProvider.$books, booksProvider.$loading).sink(receiveValue: { _ in
            self.objectWillChange.send()
        })
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = PersistenceController.shared.container.viewContext
        
        booksProvider.loader = MockBooksLoader()
    }
}
