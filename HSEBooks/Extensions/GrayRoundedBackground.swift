//
//  GrayRoundedBackground.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 23.03.2021.
//

import SwiftUI

struct GrayRoundedBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 1, y: 1)
            )
    }
}

extension View {
    func grayRoundedBackground() -> some View {
        self.modifier(GrayRoundedBackground())
    }
}
