//
//  Ad.swift
//  BookExchange
//
//  Created by Oleg Koptev on 24.01.2021.
//

import SwiftUI

struct Ad: View {
    var body: some View {
        VStack {
            Image("Ad")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
                .clipped()
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(Color("Accent"))
        }
    }
}

struct AdCollection_Previews: PreviewProvider {
    static var previews: some View {
        Ad()
    }
}
