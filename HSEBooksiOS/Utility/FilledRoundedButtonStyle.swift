//
//  FilledRoundedButtonStyle.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 13.05.2021.
//

import SwiftUI

struct FilledRoundedButtonStyle: ButtonStyle {
    var fillColor: Color = .accentColor
    var verticalPadding: CGFloat = 6
    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .foregroundColor(.white)
//            .textCase(.uppercase)
//            .padding(.vertical, verticalPadding)
//            .padding(.horizontal, 16)
//            .background(
//                Color.accentColor
//                    .cornerRadius(8)
//            )
//            .opacity(configuration.isPressed ? 0.75 : 1)
        
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(fillColor)
                .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize + verticalPadding * 2)
                .opacity(configuration.isPressed ? 0.25 : 1)
            configuration.label
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
