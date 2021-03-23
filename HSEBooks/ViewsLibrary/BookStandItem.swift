//
//  BookStandItem.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct BookStandItem: View {
    var title: String
    var author: String
    var rating: Double = 0
    var publishYear: Int = 2021
    var cover: Image?
    var body: some View {
        NavigationLink(
            destination: BookPage(title: title, author: author, rating: rating),
            label: {
                VStack(alignment: .leading, spacing: 2) {
                    BookCover(image: cover)
                        .padding(4)
                    HStack {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color("Orange"))
                                .font(.system(size: 10))
                            Text(String(rating))
                        }
                        HStack(spacing: 2) {
                            Image(systemName: "calendar.circle.fill")
                                .foregroundColor(Color("Orange"))
                                .font(.system(size: 10))
                            Text(String(publishYear))
                        }
                        Spacer(minLength: 0)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background(Color("AccentColor"))
                    Group {
                        Text(author)
                            .foregroundColor(.secondary)
                        Text(title)
                    }
                    .padding(.horizontal, 4)
                }
                .padding(.bottom, 4)
                .lineLimit(1)
                .foregroundColor(.primary)
                .font(.system(size: 12))
                .padding(2)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            .shadow(radius: 2)
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color(.systemGray6), lineWidth: 1.0, antialiased: true)
                    }
                )
            }
        )
        .buttonStyle(SlightlyPressedButtonStyle())
    }
}

struct StandBookCover_Previews: PreviewProvider {
    static var previews: some View {
        BookStandItem(title: "Title", author: "Author")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
