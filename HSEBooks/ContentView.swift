//
//  ContentView.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTab: Int = 0
    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView {
                Stand()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)
            
            NavigationView {
                Text("Page 2")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "square.grid.2x2")
                Text("Genres")
            }
            .tag(1)
            
            NavigationView {
                Text("Page 3")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "heart")
                Text("Favorites")
            }
            .tag(2)
            
            NavigationView {
                Profile()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(3)
        }
        .accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
