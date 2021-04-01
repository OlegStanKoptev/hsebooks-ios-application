//
//  ContentView.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct ContentView: View {
    enum Tab {
        case home, /* genres, favorites, */profile
    }
    
    @State private var currentTab = Tab.home
    
    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView {
                Stand(currentTab: $currentTab)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(Tab.home)
            
            NavigationView {
                Profile(currentTab: $currentTab)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(Tab.profile)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
