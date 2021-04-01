//
//  TabBar.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 27.03.2021.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var tabBarContext: TabBarContext
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
            HStack(spacing: 8) {
                ForEach(TabBarContext.Pages.allCases, id: \.self) { tab in
                    VStack(spacing: 2) {
                        Image(systemName: tab.info.1)
                            .font(.title2)
                            .frame(width:  69, height: UIFont.preferredFont(forTextStyle: .title2).pointSize + 2)
                        Text(tab.info.0)
                            .font(.caption2)
                    }
                    .foregroundColor(tabBarContext.currentTab == tab ? .orange : .gray)
                    .frame(width: UIScreen.main.bounds.width / CGFloat(TabBarContext.Pages.allCases.count) - 8)
                    .padding(.bottom, 1)
                    .padding(.top, 9)
                    .onTapGesture {
                        tabBarContext.currentTab = tab
                    }
                }
            }
            .lineLimit(1)
            .frame(width: UIScreen.main.bounds.width)
            .background(
                Color(hue: 0, saturation: 0, brightness: 0.97)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(tabBarContext: TabBarContext())
    }
}
