//
//  BookPage.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 04.02.2021.
//

import SwiftUI

struct BookPage: View {
    enum BookPageTabs: String, MenuItem, CaseIterable {
        case About, Reviews, OtherBooks = "Other Books"
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    var author: String
    var rating: Double
    
    @State var chosenTab: MenuItem = BookPageTabs.About
    let backColor: Color = Color.white.opacity(0.25)
    
    func requestBook(with message: String) {
        print("Requesting a book with a message \"\(message)\"")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
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
                    
                    HStack {
                        Spacer()
                        
                        BookCover()
                            .background(backColor)
                            .cornerRadius(12)
                            .padding(.top, 16)
                            .frame(width: UIScreen.main.bounds.width * 0.45)
                        
                        Spacer()
                    }
                }
                Text(title)
                    .font(.system(size: 20))
                    .padding(.top, 8)
                    .lineLimit(2)
                Text(author)
                    .font(.system(size: 16))
                    .foregroundColor(Color(.systemGray4))
                    .lineLimit(2)
                
                HStack {
                    RatingView(rating: rating)
                    Text(String(rating))
                        .foregroundColor(Color(.systemGray4))
                }
                .padding(.bottom, 6)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .overlay(
                            Label("User name", systemImage: "person.circle")
                        )
                    NavigationLink(
                        destination: BookRequest(title: title, author: author, sendRequestAction: requestBook),
                        label: {
                            Text("Request")
                        })
                        .buttonStyle(
                            FilledRoundedButtonStyle(
                                fillColor: .orange,
                                verticalPadding:
                                    UIFont.preferredFont(forTextStyle: .body).pointSize + 9
                            )
                        )
                }
                .background(backColor)
                .frame(height: UIFont.preferredFont(forTextStyle: .body).pointSize + 24)
            }
            .foregroundColor(.white)
            .background(
                Color("AccentColor")
                    .edgesIgnoringSafeArea(.top)
            )
            
            HStack(spacing: 6) {
                ForEach(BookPageTabs.allCases, id: \.rawValue) { tab in
                    Button(action: { chosenTab = tab }, label: {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                chosenTab.rawValue == tab.rawValue ?
                                    Color.white : backColor
                            )
                            .overlay(
                                Text(tab.rawValue)
                                    .foregroundColor(
                                        chosenTab.rawValue == tab.rawValue ?
                                            Color.orange : Color.white
                                    )
                                    .padding(.horizontal, 4)
                            )
                    })
                }
            }
            .font(.system(size: 15))
            .textCase(.uppercase)
            .lineLimit(2)
            .frame(height: UIFont.preferredFont(forTextStyle: .body).pointSize + 26)
            .padding(8)
            .background(Color("AccentColor"))
            
            Spacer(minLength: 0)
            
            switch chosenTab {
            case BookPageTabs.About:
                Text("About")
            case BookPageTabs.Reviews:
                Text("Reviews")
            case BookPageTabs.OtherBooks:
                Text("Other Books")
            default:
                Text("Not implemented yet")
            }
            
            Spacer(minLength: 0)
        }
        .navigationBarHidden(true)
    }
}

struct BookPage_Previews: PreviewProvider {
    static var previews: some View {
        BookPage(title: "Title", author: "Author", rating: 5.0)
    }
}
