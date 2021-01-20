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
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                Text("Some text")
                                    .foregroundColor(.gray)
                            )
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                    case .item2:
                        Text("Page 2 Title")
                    case .item3:
                        Text("Page 3 Title")
                    case .item4:
                        Text("Page 4 Title")
                    }
                }
                .font(.headline)
                .frame(width: geometry.size.width, height: geometry.size.height/16)
                .padding(.top, geometry.safeAreaInsets.top)
                .background(Color(.displayP3, red: 92 / 255, green: 124 / 255, blue: 192 / 255).shadow(radius: 1))
                .foregroundColor(.white)
                Spacer(minLength: 0)
                switch viewRouter.currentPage {
                case .item1:
                    ScrollView {
                        VStack(spacing: 8) {
                            BookListSection(header: "First header")
                            BookListSection(header: "Second header")
                            BookListSection(header: "Third header")
                        }
                    }
                case .item2:
                    Text("Page 2")
                case .item3:
                    Text("Page 3")
                case .item4:
                    Text("Page 4")
                }
                Spacer(minLength: 0)
                HStack {
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item1, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 1")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item2, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 2")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item3, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 3")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .item4, width: geometry.size.width/4, height: geometry.size.height/30, systemIconName: "seal", tabName: "Item 4")
                }
                .frame(width: geometry.size.width, height: geometry.size.height/(geometry.safeAreaInsets.bottom == 0 ? 12 : 14))
                .padding(.top, (geometry.safeAreaInsets.bottom == 0 ? -4 : 0))
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .background(Color(.displayP3, red: 92 / 255, green: 124 / 255, blue: 192 / 255).shadow(radius: 1))
            }
            .edgesIgnoringSafeArea(.vertical)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(viewRouter: ViewRouter())
    }
}
