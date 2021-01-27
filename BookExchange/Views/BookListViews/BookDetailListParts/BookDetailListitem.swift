//
//  BookDetailListitem.swift
//  BookExchange
//
//  Created by Oleg Koptev on 28.01.2021.
//

import SwiftUI

struct BookDetailListitem: View {
    var book: BookBase
    let rowHeight: CGFloat = 95
    @State var showMenu: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                if let pictureUrl = book.pictureUrl {
                    AsyncImage(
                        url: pictureUrl,
                        placeholder: { BookCoverPlaceholder().frame(width: 80, height: rowHeight) },
                        image: {
                            Image(uiImage: $0)
                            .resizable()
                            .renderingMode(.original)
                        }
                    )
                } else {
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .renderingMode(.original)
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: rowHeight)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .foregroundColor(.black)
                Text(book.author)
                HStack(spacing: 4) {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.orange)
                    Text(book.language)
                }
                HStack {
                    RatingView(rating: book.rating)
                }
            }
            .font(.system(size: 15))
            .foregroundColor(.gray)
            .lineLimit(1)
            Spacer(minLength: 0)
            VStack(spacing: 0) {
                Menu(content: {
                    Button(action: { print("You requested the book \(book.title)") }, label: {
                        Label(
                            title: { Text("Request") },
                            icon: { Image(systemName: "paperplane") }
                        )
                    })
                    Button(action: {}, label: {
                        Label(
                            title: { Text("Add to favorites") },
                            icon: { Image(systemName: "heart") }
                        )
                    })
                }, label: {
                    ZStack {
                        Color.clear
                            .frame(width: 24, height: 20)
                        VStack(spacing: 3) {
                            ForEach(0..<3) { _ in
                                Circle()
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .foregroundColor(Color(.darkGray))
                    }
                })
                Spacer()
            }
            .padding(.top, 12)
            .padding(.trailing, 10)
        }
        .padding(.vertical, 0)
        .background(Color.white.shadow(radius: 5))
        .padding(.vertical, 6)
    }
}

struct BookDetailListitem_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailListitem(book: BookBase(id: 1, author: "Author", language: "Eng", title: "Title", numberOfPages: 1, publishYear: 1, pictureUrl: nil, wishers: [], genres: [], rating: 5.0))
    }
}
