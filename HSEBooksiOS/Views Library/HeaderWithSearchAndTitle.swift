//
//  HeaderWithSearchAndTitle.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 20.05.2021.
//

import SwiftUI

struct HeaderWithSearchAndTitle: View {
    let title: String
    var hideBackButton: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing: 0) {
            SearchBarButton()
                .padding(.bottom, 8)
                .background(
                    Color.tertiaryColor
                        .edgesIgnoringSafeArea(.top)
                )
            
            ZStack(alignment: .leading) {
                if !hideBackButton {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        ZStack {
                            Color.clear
                                .frame(width: 48, height: UIFont.preferredFont(forTextStyle: .body).pointSize)
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }
                    }
                }

                HStack {
                    Spacer()
                    Text(title)
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                    Spacer()
                }
                .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize - 2))
                .padding(.bottom, 4)
                
            }
            .background(
                Color.tertiaryColor
            )
        }
    }
}

struct HeaderWithSearchAndTitle_Previews: PreviewProvider {
    static var previews: some View {
        HeaderWithSearchAndTitle(title: "Title")
    }
}
