//
//  RatingView.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 15.05.2021.
//

import SwiftUI

struct RatingView: View {
    var value: Double = 0
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                    .foregroundColor(Double(index) + 0.49 < value ? .accentColor : Color(.lightGray))
            }
            .font(.system(size: 14))
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(value: 4.4)
            .previewLayout(.sizeThatFits)
    }
}
