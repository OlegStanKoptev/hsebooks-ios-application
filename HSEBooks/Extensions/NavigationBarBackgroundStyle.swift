//
//  NavigationBarBackgroundStyle.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 14.03.2021.
//

import SwiftUI

struct NavigationBarBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color("AccentColor")
                    .edgesIgnoringSafeArea(.top)
            )
    }
}

extension View {
    func navigationBarBackgroundStyle() -> some View {
        self.modifier(NavigationBarBackgroundStyle())
    }
}
