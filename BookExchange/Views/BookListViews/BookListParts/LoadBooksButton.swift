//
//  LoadBooksButton.swift
//  BookExchange
//
//  Created by Oleg Koptev on 25.01.2021.
//

import SwiftUI

struct LoadBooksButton: View {
    @EnvironmentObject var context: AppContext
    
    private func load() {
        context.booksProvider.load()
    }
    var body: some View {
        VStack {
            Spacer()
            Button(action: { load() }) {
                if (!context.booksProvider.loading) {
                    RoundedRectangle(cornerRadius: 8)
                        .overlay(
                            Text("Update books list")
                                .foregroundColor(.white)
                        )
                }
            }
            .frame(width: 350, height: 40)
            .padding(.bottom, 20)
        }
    }
}

struct LoadBooksButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadBooksButton()
    }
}
