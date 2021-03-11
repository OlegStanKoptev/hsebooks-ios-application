//
//  BookListViewRouter.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import Combine

class BookListViewRouter: ObservableObject {
    @Published var currentPage: BookListPage = .item2
}

enum BookListPage: String, CaseIterable {
    case item1 = "Genres"
    case item2 = "What to read"
    case item3 = "Popular"
    case item4 = "Something more"
}
