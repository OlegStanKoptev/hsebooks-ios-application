//
//  ContentView.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                Stand()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            NavigationView {
                Text("Page 2")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "square.grid.2x2")
                Text("Genres")
            }
            
            NavigationView {
                Text("Page 3")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "heart")
                Text("Favorites")
            }
            
            NavigationView {
                Profile()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        .accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
