//
//  SlightlyPressedButtonStyle.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 15.03.2021.
//

import SwiftUI

struct SlightlyPressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
