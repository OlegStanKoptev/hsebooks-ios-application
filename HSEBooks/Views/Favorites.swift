//
//  Favorites.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 24.03.2021.
//

import SwiftUI

struct Favorites: View {
    struct Book: Identifiable {
        let id: UUID = UUID()
        var title: String = "Title"
        var author: String = "Author"
        var year: Int = 2021
        var rating: Double = 5.0
        var image: Image? = nil
    }
    
    @State var books: [Book] = [
        .init(),
        .init(),
        .init(),
        .init(),
        .init(),
    ]
    
    let actions: [BookListRowWithMenu.Action] = [
        .init(label: "Request", imageName: "paperplane"),
        .init(label: "Remove from favorites", imageName: "heart.slash")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                SearchBar(query: .constant(""))
                NavigationBar(title: "Favorites", backButtonHidden: true)
            }
            .navigationBarBackgroundStyle()
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(books) { book in
                        BookListRowWithMenu(title: book.title, author: book.author, publishYear: book.year, rating: book.rating, image: book.image, height: 120, actions: actions)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Spacer(minLength: 0)
        }
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        Favorites()
    }
}
