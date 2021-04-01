//
//  RatingView.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 15.03.2021.
//

import SwiftUI

struct RatingView: View {
    var rating: Double = 0
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                    .foregroundColor(Double(index) + 0.49 < rating ? .accentColor : Color(.lightGray))
            }
            .font(.system(size: 14))
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 4.4)
            .previewLayout(.sizeThatFits)
    }
}
