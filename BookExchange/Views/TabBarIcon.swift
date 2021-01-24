//
//  TabBarIcon.swift
//  BookExchange
//
//  Created by Oleg Koptev on 14.01.2021.
//

import SwiftUI

struct TabBarIcon: View {
    @ObservedObject var viewRouter: ViewRouter
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
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color.orange : Color(UIColor.darkGray))
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
    }
}
