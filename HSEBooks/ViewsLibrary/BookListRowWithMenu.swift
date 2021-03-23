//
//  BookListRowWithMenu.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct BookListRowWithMenu: View {
    struct Action: Identifiable {
        let id = UUID()
        var label: String
        var imageName: String?
        var onPressed: (() -> Void)?
    }
    
    let title: String
    let author: String
    let publishYear: Int
    let rating: Double
    var image: Image?
    let height: CGFloat
    var actions: [Action]?
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination:
                    BookPage(title: title, author: author, rating: rating),
                label: {
                    BookListRowBase(title: title, author: author, height: height, trailingPadding: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(Color("Orange"))
                                    .font(.system(size: 14))
                                Text(String(publishYear))
                            }
                            
                            HStack(spacing: 4) {
                                RatingView(rating: rating)
                                Text(String(rating))
                            }
                        }
                    }
                }
            )
            .buttonStyle(SlightlyPressedButtonStyle())
        }
        .overlay(
            HStack {
                if let actions = actions {
                    Spacer()
                    VStack {
                        Menu {
                            ForEach(actions) { action in
                                Button(action: { action.onPressed?() }) {
                                    if let imageName = action.imageName {
                                        Label(action.label, systemImage: imageName)
                                    } else {
                                        Text(action.label)
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                Color.clear
                                    .frame(width: 20, height: 32)
                                VStack(spacing: 2) {
                                    ForEach(0..<3) { _ in
                                        Circle()
                                            .frame(width: 6, height: 6)
                                    }
                                    .foregroundColor(Color.black.opacity(0.8))
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                }
            }
        )
    }
}

struct BookListRowWithMenu_Previews: PreviewProvider {
    static let actions: [BookListRowWithMenu.Action] = [
        .init(label: "Request", imageName: "paperplane"),
        .init(label: "Add To Favorites", imageName: "heart")
    ]
    
    static var previews: some View {
        BookListRowWithMenu(title: "Title", author: "Author", publishYear: 2020, rating: 5.0, height: 120, actions: actions)
        .previewLayout(.sizeThatFits)
    }
}
