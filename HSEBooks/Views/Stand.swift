//
//  Stand.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct Stand: View {
    enum MenuItems: String, MenuItem, CaseIterable {
        case Genres
        case WhatToRead = "What to read"
        case Popular
        case Collection
        case New
    }
    
    @State private var query: String = ""
    @State private var chosenMenuItem: MenuItem = MenuItems.WhatToRead
    @State private var initialChosenMenuSet = false
    var body: some View {
        VStack(spacing: 0) {
            Group {
                SearchBar(placeholderText: "Search...", query: $query)
                HorizontalMenu(items: MenuItems.allCases, chosenItem: $chosenMenuItem)
            }
            .navigationBarBackgroundStyle()
            
            Spacer(minLength: 0)
            
            switch chosenMenuItem {
            case MenuItems.Genres:
                GenresStand()
            case MenuItems.WhatToRead:
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
        Stand()
    }
}
