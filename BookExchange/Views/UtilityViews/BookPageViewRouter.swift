//
//  BookPageViewRouter.swift
//  BookExchange
//
//  Created by Oleg Koptev on 05.02.2021.
//

import SwiftUI

class BookPageViewRouter: ObservableObject {
    @Published var currentPage: BookPageTab = .item1
}

enum BookPageTab: String, CaseIterable {
    case item1 = "About"
    case item2 = "Reviews"
    case item3 = "Other books"
}
