//
//  BooksLoading.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.01.2021.
//

import Foundation

protocol BooksLoading {
    func load(_ handler: @escaping (_ books: [BookBase_deprecated]) -> Void)
}
