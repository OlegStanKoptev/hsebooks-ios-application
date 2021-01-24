//
//  TabBarWrapper.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct TabBarWrapper: ViewModifier {
    init() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .darkGray
    }
    
    func body(content: Content) -> some View {
        return content
            .accentColor(.orange)
    }
}

extension View {
    func styleTabBar() -> some View {
        modifier(TabBarWrapper())
    }
}
