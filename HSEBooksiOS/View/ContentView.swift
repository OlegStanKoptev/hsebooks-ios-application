//
//  ContentView.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 22.04.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appContext = AppContext.shared
//    @State var authScreenPresented: Bool = false
    @State var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomePage()
                .tag(1)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            MyBooksPage(selectedTab: $selectedTab)
                .tag(2)
                .tabItem {
                    Label("My Books", systemImage: "book")
                }
            
            MyRequestsPage(selectedTab: $selectedTab)
                .tag(3)
                .tabItem {
                    Label("My Requests", systemImage: "bubble.left.and.bubble.right")
                }
            
            ProfilePage(selectedTab: $selectedTab)
                .tag(4)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
//        .animation(.none)
//        .fullScreenCover(isPresented: $authScreenPresented) {
//            AuthPage()
//        }
        .sheet(isPresented: $appContext.searchIsPresented) {
            SearchPage() { appContext.searchIsPresented = false }
        }
//        .onChange(of: appContext.isLoggedIn) { value in
//            authScreenPresented = !value
//        }
//        .onAppear {
//            authScreenPresented = !appContext.isLoggedIn
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appContext: .preview)
    }
}
