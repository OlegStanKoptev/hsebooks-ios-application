//
//  CustomTabView.swift
//  BookExchange
//
//  Created by Oleg Koptev on 14.01.2021.
//

import SwiftUI

struct CustomTabView: View {
    
    @StateObject var viewRouter: ViewRouter
//    @State var authorized: Bool = false
    @State var showingAuthScreen: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    switch viewRouter.currentPage {
                    case .item1:
                        Text("Page 1 Title")
                    case .item2:
                        Text("Page 2 Title")
                    case .item3:
                        Text("Page 3 Title")
                    case .item4:
                        Text("Page 4 Title")
                    }
//                    Text(viewRouter.currentPage.rawValue)
//                        .font(.headline)
//                    Text("Authorization status: " + (authorized ? "+" : "-"))
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
                }
                .font(.headline)
                .frame(width: geometry.size.width, height: geometry.size.height/16)
                .padding(.top, geometry.safeAreaInsets.top)
                .background(Color(UIColor.secondarySystemBackground).shadow(radius: 1))
                Spacer()
                switch viewRouter.currentPage {
                case .item1:
                    Text("Page 1")
                //BookListItem()
                case .item2:
                    Text("Page 2")
                case .item3:
                    Text("Page 3")
                case .item4:
                    Text("Page 4")
//                    Button("Auth Screen") {
//                        self.showingAuthScreen.toggle()
//                    }.sheet(isPresented: $showingAuthScreen) {
//                        VStack {
//                            HStack {
//                                Button(action: { self.showingAuthScreen.toggle() }, label: { Text("Close").bold() })
//                                    .padding(.horizontal, 12)
//                                Spacer()
//                            }
//                            .frame(width: geometry.size.width, height: geometry.size.height/14)
//                            .background(Color(UIColor.secondarySystemBackground).shadow(radius: 1))
//                            Spacer()
//                            //AuthorizationView(authorized: $authorized)
//                            Spacer()
//                        }
//                    }
                }
                Spacer()
                HStack {
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item1, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 1")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item2, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 2")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item3, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 3")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item4, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 4")
                }
                .frame(width: geometry.size.width, height: geometry.size.height/(geometry.safeAreaInsets.bottom == 0 ? 12 : 14))
                .padding(.top, (geometry.safeAreaInsets.bottom == 0 ? -4 : 0))
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .background(Color(UIColor.secondarySystemBackground).shadow(radius: 1))
            }
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(viewRouter: ViewRouter())
    }
}
