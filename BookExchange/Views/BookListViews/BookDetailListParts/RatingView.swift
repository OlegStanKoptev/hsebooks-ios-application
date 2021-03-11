//
//  RatingView.swift
//  BookExchange
//
//  Created by Oleg Koptev on 28.01.2021.
//

import SwiftUI

struct RatingView: View {
    let rating: Float
    let symbolSize: CGFloat = 17
    
    func countWidth(_ index: Int) -> CGFloat {
        if (rating <= Float(index)) {
            return 0;
        }
        return CGFloat(rating - Float(index)) * (symbolSize + 2)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        if (Int(rating) - index <= 0) {
                            ZStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(.lightGray))
                                HStack {
                                    Color.orange
                                        .frame(width: countWidth(index))
                                    Spacer(minLength: 0)
                                }
                                .mask(Image(systemName: "star.fill"))
                            }
                            .frame(width: symbolSize + 2, height: symbolSize)
                        } else {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
            Text(String(rating))
            Spacer(minLength: 0)
        }
        .font(.system(size: 15))
        .frame(width: (symbolSize + 2) * 5 + 32)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<21) { index in
                RatingView(rating: Float(index) / 20 * 5.0)
            }
        }
        .frame(width: 150)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
