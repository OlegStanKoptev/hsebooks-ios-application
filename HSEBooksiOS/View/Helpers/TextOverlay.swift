//
//  TextOverlay.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 24.04.2021.
//

import SwiftUI

struct TextOverlay: View {
    let text: String
    var body: some View {
        Text(text)
            .padding()
            .background(Color(.systemGray5).cornerRadius(12))
            .transition(.opacity)
            .animation(.easeInOut)
    }
}
