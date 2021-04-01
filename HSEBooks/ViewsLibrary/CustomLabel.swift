//
//  CustomLabel.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct CustomLabel: View {
    let text: String
    let image: Image
    let imageColor: Color
    var body: some View {
        HStack {
            image
                .resizable()
                .foregroundColor(imageColor)
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: UIFont.preferredFont(forTextStyle: .body).pointSize + 18,
                    height: UIFont.preferredFont(forTextStyle: .body).pointSize + 12
                )
                
            HStack {
                Text(text)
                Spacer()
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 1, y: 1)
            )
        }
    }
}

struct CustomLabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomLabel(text: "Name", image: Image(systemName: "person.circle.fill"), imageColor: Color("SecondColor"))
            CustomLabel(text: "Moscow",image: Image(systemName: "pin.fill"), imageColor: .accentColor)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
