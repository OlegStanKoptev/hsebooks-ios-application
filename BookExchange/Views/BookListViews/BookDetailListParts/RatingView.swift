//
//  RatingView.swift
//  BookExchange
//
//  Created by Oleg Koptev on 28.01.2021.
//

import SwiftUI

struct RatingView: View {
    let rating: Float
    let width: CGFloat = 97.5
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(.lightGray))
                    }
                    Spacer(minLength: 0)
                }
                HStack {
                    Color.orange
                        .frame(width: CGFloat(rating) / 5.0 * width)
                    Spacer(minLength: 0)
                }
                .mask(
                    HStack(spacing: 0) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                        }
                        Spacer(minLength: 0)
                    }
                )
//                HStack {
//                    Color.clear
//                        .frame(width: CGFloat(rating) / 5.0 * width)
//                        .border(Color.red)
//                    Spacer(minLength: 0)
//                }
            }
            Text(String(rating))
            Spacer(minLength: 0)
        }
        .font(.system(size: 15))
        .frame(width: width + 26, height: 18)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            ForEach(1..<21) { index in
                RatingView(rating: Float(index) / 20 * 5.0)
            }
        }
        .frame(width: 150)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
