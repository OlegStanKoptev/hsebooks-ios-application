//
//  WishlistPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct WishlistPage: View {
    @EnvironmentObject var appState: AppState
    @StateObject var model: PreloadedDataViewModel<BookBase> = RealPreloadedDataViewModel()
    
    func fetchData() {
        model.fetch(appState.authData.currentUser?.wishListIds, from: BookBase.book, with: appState)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if model.items.isEmpty && appState.authData.authState != .loading {
                    Text("You wishlist is empty!")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(model.items) { book in
                            Text(book.title)
                        }
                    }
                }
            }
            .overlay(StatusOverlay(viewState: $model.viewState))
            .onChange(of: appState.authData.isLoggedIn) { _ in
                fetchData()
            }
            .onAppear {
                fetchData()
            }
            .navigationTitle("Wishlist")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FavoritesPage_Previews: PreviewProvider {
    static var previews: some View {
        WishlistPage(model: MockPreloadedDataViewModel<BookBase>())
            .environmentObject(AppState.preview)
    }
}
