//
//  ContentView.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.12.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomTabView()
            .environmentObject(AppContext())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
