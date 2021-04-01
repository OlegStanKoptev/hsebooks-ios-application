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
        var base: BookBase = .previewInstance
    }
    
//    @EnvironmentObject var tabBarContext: TabBarContext
    @State var books: [Book] = [
        .init(),
        .init(),
        .init(),
        .init(),
        .init(),
    ]
    
    var backButtonHidden: Bool = false
    
    let actions: [BookListRowWithMenu.Action] = [
        .init(label: "Request", imageName: "paperplane"),
        .init(label: "Remove from favorites", imageName: "heart.slash")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                SearchBar(query: .constant(""))
                NavigationBar(title: "Favorites", backButtonHidden: backButtonHidden)
            }
            .navigationBarBackgroundStyle()
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(books) { book in
                        BookListRowWithMenu(book: book.base, height: 120, actions: actions)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Spacer(minLength: 0)
            
//            TabBar(tabBarContext: tabBarContext)
        }
        .navigationBarHidden(true)
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        Favorites()
//            .environmentObject(TabBarContext())
    }
}
