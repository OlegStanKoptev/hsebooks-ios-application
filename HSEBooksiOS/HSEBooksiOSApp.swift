//
//  HSEBooksiOSApp.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 22.04.2021.
//

import SwiftUI

@main
struct HSEBooksiOSApp: App {
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(Color.tertiaryColor)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
