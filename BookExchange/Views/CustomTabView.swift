//
//  CustomTabView.swift
//  BookExchange
//
//  Created by Oleg Koptev on 14.01.2021.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var context: AppContext
//    @StateObject var viewRouter = ViewRouter()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                BookList(size: geometry.size)
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
        
        
//        GeometryReader { geometry in
//            VStack {
//                switch viewRouter.currentPage {
//                case .item1:
//                    BookList(size: geometry.size)
//                        .wrapNavigationView()
//                case .item2:
//                    Text("Page 2")
//                case .item3:
//                    Text("Page 3")
//                case .item4:
//                    Text("Page 4")
//                }
//                Spacer(minLength: 0)
//                HStack {
//                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item1, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "house", tabName: "Home")
//                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item2, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "square.grid.2x2", tabName: "Genres")
//                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item3, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "heart", tabName: "Favorites")
//                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item4, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "person", tabName: "Profile")
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height/(geometry.safeAreaInsets.bottom == 0 ? 12 : 14))
//                .padding(.top, (geometry.safeAreaInsets.bottom == 0 ? -4 : 0))
//                .padding(.bottom, geometry.safeAreaInsets.bottom)
//                .background(Color(.displayP3, red: 249 / 255, green: 249 / 255, blue: 250 / 255).shadow(radius: 1))
//            }
//            .edgesIgnoringSafeArea(.vertical)
//        }
//        .ignoresSafeArea(.keyboard)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
