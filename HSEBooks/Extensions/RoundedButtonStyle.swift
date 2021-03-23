//
//  RoundedButtonStyle.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(color, lineWidth: 1.0, antialiased: true)
                .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize + 12)
                .opacity(configuration.isPressed ? 0.25 : 1)
            configuration.label
                .font(.subheadline)
                .foregroundColor(color)
        }
    }
}
