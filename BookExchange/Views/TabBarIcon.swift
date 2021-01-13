//
//  TabBarIcon.swift
//  BookExchange
//
//  Created by Oleg Koptev on 14.01.2021.
//

import SwiftUI

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
        }
        .padding(.horizontal, -4)
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color.black : .gray)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
    }
}
