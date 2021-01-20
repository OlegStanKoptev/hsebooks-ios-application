//
//  BookListIcon.swift
//  BookExchange
//
//  Created by Oleg Koptev on 15.01.2021.
//

import SwiftUI

struct BookListIcon: View {
    var author: String = "Author Name"
    var title: String = "Book Name"
    var rating: Float = 5.0
    var city: String = "City"
    var picture: Image = Image("Book Cover")
    
    var size: CGSize = UIScreen.main.bounds.size
    let textLeadingPadding: CGFloat = 8
    
    var body: some View {
        VStack(spacing: 6) {
            picture
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(4)
            HStack(spacing: 12) {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                    Text(String(rating))
                }
                HStack(spacing: 2) {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text(city)
                }
                Spacer()
            }
            .font(.body)
            .padding(.leading, textLeadingPadding)
            .padding(.vertical, 3)
            .background(Color(.displayP3, red: 92 / 255, green: 124 / 255, blue: 192 / 255))
            .foregroundColor(.white)
            HStack {
                Text(author)
                    .foregroundColor(Color.init(.displayP3, red: 206 / 255, green: 207 / 255, blue: 207 / 255))
                    .padding(.leading, textLeadingPadding)
                Spacer()
            }
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                    .padding(.leading, textLeadingPadding)
                Spacer()
            }
            .padding(.bottom, 16)
        }
        .lineLimit(1)
        .frame(width: size.width * 0.4, height: size.width * 0.4 + 100)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.displayP3, red: 231 / 255, green: 231 / 255, blue: 223 / 255), lineWidth: 2))
        .background(Color.white.cornerRadius(6).shadow(radius: 2))
    }
}

struct BookListIcon_Previews: PreviewProvider {
    static var previews: some View {
        BookListIcon()
    }
}
