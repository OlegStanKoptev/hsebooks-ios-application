//
//  HSEBooksApp.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

@main
struct HSEBooksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(WhatToReadStandStore())
        }
    }
}
