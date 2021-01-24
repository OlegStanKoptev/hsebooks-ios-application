//
//  NavigationBarWrapper.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct NavitaionBarWrapper: ViewModifier {
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = UIColor(named: "Accent")
        navBarAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    func body(content: Content) -> some View {
        return NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
        }
    }
}

extension View {
    func styleNavigationBar() -> some View {
        modifier(NavitaionBarWrapper())
    }
}
