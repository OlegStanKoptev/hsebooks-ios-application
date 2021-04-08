//
//  StandViewModel.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 28.03.2021.
//

import Foundation

class StandViewModel: ObservableObject {
    enum MenuItems: String, MenuItem, CaseIterable {
        case Genres
        case WhatToRead = "What to read"
        case Popular
        case Collection
        case New
    }
    
    @Published var chosenMenuItem: MenuItem
    
    init(initialMenuPage: MenuItem) {
        chosenMenuItem = initialMenuPage
    }
}
