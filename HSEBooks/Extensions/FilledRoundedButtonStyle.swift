//
//  FilledRoundedButtonStyle.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct FilledRoundedButtonStyle: ButtonStyle {
    let fillColor: Color
    var verticalPadding: CGFloat = 12
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(fillColor)
                .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize + verticalPadding)
                .opacity(configuration.isPressed ? 0.25 : 1)
            configuration.label
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
