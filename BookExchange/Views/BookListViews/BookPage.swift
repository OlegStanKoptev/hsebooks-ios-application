//
//  BookPage.swift
//  BookExchange
//
//  Created by Oleg Koptev on 04.02.2021.
//

import SwiftUI

struct BookPage: View {
    @ObservedObject var viewRouter: BookPageViewRouter = BookPageViewRouter()
    var title: String
    var author: String
    var rating: Float
    var pictureUrl: URL?
    var body: some View {
        ZStack {
            Color("Accent")
                .edgesIgnoringSafeArea(.top)
            GeometryReader { geo in
                VStack(spacing: 0) {
                    TopPartView(title: title, author: author, rating: rating, pictureUrl: pictureUrl, viewRouter: viewRouter, geo: geo)
                    Spacer(minLength: 0)
                    switch viewRouter.currentPage {
                    case .item1:
                        VStack {
                            HStack {
                                Text("Genre: some kind of genre")
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                Rectangle()
                                    .foregroundColor(.white)
                                    .shadow(color: .init(.systemGray3), radius: 4, x: 0.0, y: 4)
                            )
                            HStack {
                                Text("Very long description...")
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            Spacer(minLength: 0)
                        }
                        .frame(width: geo.size.width)
                    case .item2:
                        Text("Not ready yet")
                    case .item3:
                        Text("Still not ready yet")
                    }
                    Spacer(minLength: 0)
                }
                .background(Color.white)
            }
            .navigationBarHidden(true)
        }
    }
}

struct BookPage_Previews: PreviewProvider {
    static var previews: some View {
        BookPage(title: "Title", author: "Author", rating: 5.0)
    }
}

struct TopPartView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    var author: String
    var rating: Float
    var pictureUrl: URL?
    @ObservedObject var viewRouter: BookPageViewRouter
    var geo: GeometryProxy
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                    })
                    Spacer()
                    HStack(spacing: 18) {
                        Button(action: {}, label: {
                            Image(systemName: "heart")
                        })
                        Button(action: {}, label: {
                            Image(systemName: "square.and.arrow.up")
                        })
                    }
                }
                .font(.system(size: 20))
                .padding(.top, 12)
                .padding(.horizontal, 18)
                Group {
                    if let pictureUrl = pictureUrl {
                        AsyncImage(
                            url: pictureUrl,
                            placeholder: { BookCoverPlaceholder().frame(width: geo.size.width * 0.45, height: geo.size.width * 0.55) },
                            image: { Image(uiImage: $0).resizable().renderingMode(.original) }
                        )
                    } else {
                        Image("Book Cover")
                            .resizable()
                            .renderingMode(.original)
                    }
                }
                    .aspectRatio(contentMode: .fit)
                    .padding(12)
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(12)
                    .frame(width: geo.size.width * 0.45, height: geo.size.width * 0.55)
                    .padding(.top, 16)
            }
            Text(title)
                .font(.system(size: 20))
                .padding(.top, 8)
                .lineLimit(2)
            Text(author)
                .font(.system(size: 16))
                .foregroundColor(.init(hue: 0, saturation: 0, brightness: 0.8))
                .lineLimit(2)
            RatingView(rating: rating)
                .padding(.top, 4)
            
            ZStack {
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.25))
                HStack(spacing: 0) {
                    Label(
                        title: {
                            Text("User name")
                        },
                        icon: {
                            Image(systemName: "person.circle")
                        }
                    )
                    .frame(width: geo.size.width * 0.5)
                    Button(action: {}, label: {
                        GeometryReader { geo2 in
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.orange)
                                .overlay(Text("Request"))
                        }
                    })
                    .frame(width: geo.size.width * 0.5)
                }
            }
            .frame(height: 40)
            .padding(.top, 12)
            
            HStack(spacing: 8) {
                ForEach(BookPageTab.allCases, id: \.rawValue) { tab in
                    Button(action: { viewRouter.currentPage = tab }, label: {
                        Group {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(viewRouter.currentPage == tab ? Color.white : Color.white.opacity(0.25))
                                .overlay(
                                    Text(tab.rawValue)
                                        .foregroundColor(viewRouter.currentPage == tab ? Color.orange : Color.white)
                                )
                        }
                    })
                }
            }
            .font(.system(size: 15))
            .textCase(.uppercase)
            .lineLimit(2)
            .frame(height: 40)
            .padding(.top, 4)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color("Accent"))
        .foregroundColor(.white)
    }
}
