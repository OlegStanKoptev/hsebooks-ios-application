//
//  TabBarContext.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 27.03.2021.
//

import Foundation

class TabBarContext: ObservableObject {
    enum Pages: Equatable, CaseIterable {
        case home
        case genres
        case favorites
        case profile
        
        var info: (label: String, systemImage: String) {
            switch self {
            case .home:
                return ("Home", "house")
            case .genres:
                return ("Genres", "square.grid.2x2")
            case .favorites:
                return ("Favorites", "heart")
            case .profile:
                return ("Profile", "person")
            }
        }
    }
    
    @Published var currentTab: Pages = .home
    @Published var isHidden: Bool = false
}
