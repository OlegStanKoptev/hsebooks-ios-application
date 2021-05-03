//
//  WishlistPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct WishlistPage: View {
    @EnvironmentObject var auth: AuthData
    @StateObject var model = WishedBooksListViewModel()
    
    func fetchData() {
        model.fetch(with: BookBase.wishlist, and: auth)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.wishlist) { book in
                    Text(book.title)
                }
            }
            .onAppear {
                fetchData()
            }
            .navigationTitle(BookBase.wishlist.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FavoritesPage_Previews: PreviewProvider {
    static var previews: some View {
        WishlistPage(model: .preview)
            .environmentObject(AuthData.preview)
    }
}
