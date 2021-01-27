//
//  BookCoverPlaceholder.swift
//  BookExchange
//
//  Created by Oleg Koptev on 27.01.2021.
//

import SwiftUI

struct BookCoverPlaceholder: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 0)
                HStack {
                    Spacer(minLength: 0)
                    
                    ZStack {
                        Image(systemName: "rectangle.portrait")
                            .font(.system(size: geometry.size.width * 1.1, weight: .ultraLight, design: .default))
                            .padding(.horizontal, -38)
                            .padding(.vertical, -20)
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: geometry.size.width * 0.4))
                    }
                    .foregroundColor(Color(.lightGray))
                    .aspectRatio(contentMode: .fit)
                    
                    Spacer(minLength: 0)
                }
                Spacer(minLength: 0)
            }
        }
    }
}

struct BookCoverPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        BookCoverPlaceholder()
    }
}
