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
    
    let book: BookBase
    let height: CGFloat
    var actions: [Action]?
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination:
                    BookPage(book: book),
                label: {
                    BookListRowBase(title: book.title, author: book.author, photoId: book.photoId, height: height, trailingPadding: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 14))
                                Text(String(book.publishYear))
                            }
                            
                            HStack(spacing: 4) {
                                RatingView(rating: book.rating)
                                Text(String(book.rating))
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
        BookListRowWithMenu(book: BookBase.previewInstance, height: 120, actions: actions)
        .previewLayout(.sizeThatFits)
    }
}
