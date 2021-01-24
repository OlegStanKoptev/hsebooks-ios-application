//
//  TableViewWrapper.swift
//  BookExchange
//
//  Created by Oleg Koptev on 25.01.2021.
//

import SwiftUI

struct TableViewWrapper: ViewModifier {
    init() {
        UITableView.appearance().separatorColor = .clear
    }
    
    func body(content: Content) -> some View {
        return content
    }
}

extension View {
    func styleTableView() -> some View {
        modifier(TableViewWrapper())
    }
}
