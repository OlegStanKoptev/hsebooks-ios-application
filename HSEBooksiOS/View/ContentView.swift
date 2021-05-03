//
//  ContentView.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 22.04.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthData
    @EnvironmentObject var model: HomeData
    @State var authScreenPresented: Bool = false
    
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            GenresPage()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Genres")
                }
            
            WishlistPage()
                .tabItem {
                    Image(systemName: "list.star")
                    Text("Wishlist")
                }
            
            ProfilePage()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .fullScreenCover(isPresented: $authScreenPresented) {
            AuthPage()
        }
        .onChange(of: auth.isLoggedIn, perform: { value in
            authScreenPresented = !value
        })
        .onAppear {
            authScreenPresented = !auth.isLoggedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthData.preview)
            .environmentObject(HomeData.preview)
    }
}
