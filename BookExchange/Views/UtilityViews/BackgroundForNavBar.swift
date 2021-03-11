//
//  BackgroundForNavBar.swift
//  BookExchange
//
//  Created by Oleg Koptev on 05.02.2021.
//

import SwiftUI

struct BackgroundForNavBar: ViewModifier {
    var height: CGFloat
    func body(content: Content) -> some View {
        return content
            .background(
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        Color("Accent")
                            .frame(height: geo.safeAreaInsets.top + height)
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(.top)
                }
            )
    }
}

extension View {
    func backgroundForNavBar(height: CGFloat) -> some View {
        modifier(BackgroundForNavBar(height: height))
    }
}
