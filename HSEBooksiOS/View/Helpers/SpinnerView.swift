//
//  SpinnerView.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 24.04.2021.
//

import SwiftUI

struct SpinnerView: View {
    var body: some View {
        ProgressView()
            .padding()
            .background(Color(.systemGray5).cornerRadius(12))
            .transition(.opacity)
            .animation(.easeInOut)
    }
}
