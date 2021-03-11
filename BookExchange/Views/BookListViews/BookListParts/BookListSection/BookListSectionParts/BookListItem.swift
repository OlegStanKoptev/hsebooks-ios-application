//
//  BookListIcon.swift
//  BookExchange
//
//  Created by Oleg Koptev on 15.01.2021.
//

import SwiftUI

struct BookListItem: View, Identifiable {
    @EnvironmentObject var context: AppContext
    let id: UUID = UUID()
    
    var author: String = "Author Name"
    var title: String = "Book Name"
    var rating: Float = 5.0
    var city: String = "City"
    var picture: Image = Image(systemName: "book.closed.fill")
    var pictureUrl: URL?
    
    let size: CGSize = UIScreen.main.bounds.size
    let textLeadingPadding: CGFloat = 8
    
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                    Group {
                        if let pictureUrl = pictureUrl {
                            AsyncImage(
                                url: pictureUrl,
                                placeholder: { BookCoverPlaceholder().frame(width: 100, height: size.width * 0.38) },
                                image: { Image(uiImage: $0).resizable().renderingMode(.original) }
                            )
                        } else {
                            picture
                                .resizable()
                                .renderingMode(.original)
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.orange)
                            Text(String(rating))
                        }
                        HStack(spacing: 2) {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.orange)
                            Text(city)
                        }
                        Spacer(minLength: 0)
                    }
                    .font(.system(size: 12))
                    .padding(.leading, textLeadingPadding)
                    .padding(.vertical, 3)
                    .background(Color("Accent"))
                    .foregroundColor(.white)
                    HStack {
                        Text(author)
                            .foregroundColor(Color.init(.displayP3, red: 206 / 255, green: 207 / 255, blue: 207 / 255))
                            .padding(.leading, textLeadingPadding)
                        Spacer()
                    }
                    .font(.system(size: 13))
                    HStack {
                        Text(title)
                            .foregroundColor(.primary)
                            .padding(.leading, textLeadingPadding)
                        Spacer()
                    }
                    .font(.system(size: 13))
                    .padding(.bottom, 8)
                }
                .lineLimit(1)
                .frame(width: size.width * 0.35, height: size.width * 0.35 + 100)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.displayP3, red: 231 / 255, green: 231 / 255, blue: 223 / 255), lineWidth: 2))
                .background(Color.white.cornerRadius(6).shadow(radius: 2))
            NavigationLink(destination: BookPage(title: title, author: author, rating: rating, pictureUrl: pictureUrl)) {
                Color.clear
            }
        }
    }
}

struct BookListIcon_Previews: PreviewProvider {
    static var previews: some View {
        BookListItem()
    }
}
