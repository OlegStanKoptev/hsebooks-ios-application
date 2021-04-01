//
//  NavigationBar.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct NavigationBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let title: String
    var backButtonHidden: Bool = false
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text(title)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .lineLimit(1)
                    .padding(.vertical, 6)
                Spacer()
            }
            if !backButtonHidden {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                        ZStack {
                            Color.clear
                                .frame(width: 48, height: 32)
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }
                    })
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
        .background(Color("SecondColor"))
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "default")
            .previewLayout(.sizeThatFits)
    }
}
