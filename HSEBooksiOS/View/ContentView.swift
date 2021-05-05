//
//  ContentView.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 22.04.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State var authScreenPresented: Bool = false
    
    var body: some View {
        TabView(selection: $appState.chosenTab) {
            HomePage()
                .tag(AppState.TabPage.home)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            GenresPage()
                .tag(AppState.TabPage.genres)
                .tabItem {
                    Label("Genres", systemImage: "square.grid.2x2")
                }
            
            WishlistPage()
                .tag(AppState.TabPage.favorites)
                .tabItem {
                    Label("Wishlist", systemImage: "list.star")
                }
            
            ProfilePage()
                .tag(AppState.TabPage.profile)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .fullScreenCover(isPresented: $authScreenPresented) {
            AuthPage()
                .environmentObject(appState)
        }
        .onChange(of: appState.authData.isLoggedIn, perform: { value in
            authScreenPresented = !value
        })
        .onAppear {
            authScreenPresented = !appState.authData.isLoggedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState.preview)
    }
}
