//
//  BookStandItem.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct BookStandItem: View {
    var book: BookBase
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            BookCover(photoId: book.photoId)
                .padding(4)
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 10))
                    Text(String(book.rating))
                }
                HStack(spacing: 2) {
                    Image(systemName: "calendar.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 10))
                    Text(String(book.publishYear))
                }
                Spacer(minLength: 0)
            }
            .foregroundColor(.white)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(Color("SecondColor"))
            Group {
                Text(book.author)
                    .foregroundColor(.secondary)
                Text(book.title)
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
}

struct StandBookCover_Previews: PreviewProvider {
    static var previews: some View {
        BookStandItem(book: .previewInstance)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
