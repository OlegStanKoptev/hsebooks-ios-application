//
//  ViewRouter.swift
//  BookExchange
//
//  Created by Oleg Koptev on 14.01.2021.
//

import SwiftUI

class ViewRouter: ObservableObject {
    var fixedPage: Page?
    @Published var currentPage: Page = .item1
}

enum Page: String {
    case item1, item2, item3, item4
}
