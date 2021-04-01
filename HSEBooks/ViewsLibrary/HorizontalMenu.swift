//
//  HorizontalMenu.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct HorizontalMenu: View {
    let items: [MenuItem]?
    var chosenItem: Binding<MenuItem>?
    var handler: ((MenuItem) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                if let items = items {
                    ForEach(items, id: \.rawValue) { item in
                        Button(action: {
                            handler?(item)
                        }, label: {
                            Text(item.rawValue)
                                .font(.system(size: 15))
                                .textCase(.uppercase)
                                .foregroundColor(item.rawValue == chosenItem?.wrappedValue.rawValue ?? "" ? .accentColor : .white)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
    }
}

struct HorizontalMenu_Previews: PreviewProvider {
    enum MenuItems: String, MenuItem, CaseIterable {
        case Genres
        case WhatToRead = "What to read"
        case Popular
        case Collection
        case New
    }
    static var previews: some View {
        HorizontalMenu(items: MenuItems.allCases, chosenItem: .constant(MenuItems.Genres))
            .previewLayout(.sizeThatFits)
            .background(Color("SecondColor"))
    }
}
