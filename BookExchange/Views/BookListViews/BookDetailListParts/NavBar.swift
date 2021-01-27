//
//  NavBar.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.01.2021.
//

import SwiftUI

struct NavBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let header: String
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            ZStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                        Image(systemName: "arrow.left")
                    })
                    Spacer()
                }
                Text(header)
                    .padding(.horizontal, 32)
            }
            Spacer(minLength: 0)
        }
        .font(.system(size: 17))
        .textCase(.uppercase)
        .foregroundColor(.white)
        .frame(height: Constants.navBarChinHeight)
        .padding(.horizontal, 18)
        .background(Color("Accent"))
        .navigationBarBackButtonHidden(true)
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(header: "header")
    }
}
