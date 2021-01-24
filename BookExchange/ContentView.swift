//
//  ContentView.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.12.2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var context: AppContext
    
    var body: some View {
        TabView {
            BookList()
                .styleNavigationBar()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            Text("Page 2")
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Genres")
                }
            Text("Page 3")
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
            Text("Page 4")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .styleTabBar()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
