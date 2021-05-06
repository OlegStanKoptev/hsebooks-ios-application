//
//  ContentView.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 22.04.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authData: AuthData
    @State var authScreenPresented: Bool = false
    
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
//            MyBooksPage()
//                .tabItem {
//                    Label("My Books", systemImage: "square.grid.2x2")
//                }
            
//            WishlistPage()
//                .tabItem {
//                    Label("Wishlist", systemImage: "list.star")
//                }
            
            ProfilePage()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .fullScreenCover(isPresented: $authScreenPresented) {
            AuthPage()
        }
        .onChange(of: authData.isLoggedIn, perform: { value in
            authScreenPresented = !value
        })
        .onAppear {
            authScreenPresented = !authData.isLoggedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthData.preview)
    }
}
