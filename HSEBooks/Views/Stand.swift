//
//  Stand.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct Stand: View {
    @Binding var currentTab: ContentView.Tab
    @StateObject var viewModel = StandViewModel(initialMenuPage: StandViewModel.MenuItems.WhatToRead)
    @State private var query: String = ""
    var body: some View {
        VStack(spacing: 0) {
            Group {
                SearchBar(query: $query)
                HorizontalMenu(items: StandViewModel.MenuItems.allCases, chosenItem: $viewModel.chosenMenuItem) { menuItem in
                    viewModel.chosenMenuItem = menuItem
                }
            }
            .navigationBarBackgroundStyle()
            
            Spacer(minLength: 0)
            
            switch viewModel.chosenMenuItem {
            case StandViewModel.MenuItems.Genres:
                GenresStand()
            case StandViewModel.MenuItems.WhatToRead:
                WhatToReadStand()
            default:
                Text("Not ready yet!")
            }
            
            Spacer(minLength: 0)
        }
        .navigationBarHidden(true)
    }
}

struct Stand_Previews: PreviewProvider {
    static var previews: some View {
        Stand(currentTab: .constant(.home))
            .environmentObject(WhatToReadStandStore())
    }
}
