//
//  HSEBooksiOSApp.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 22.04.2021.
//

import SwiftUI

@main
struct HSEBooksiOSApp: App {
    @AppStorage("hsebooks-auth-token") var token: String = ""
    @ObservedObject var appContext = AppContext.shared
    
    init() {
        UINavigationBar.setupAppColorTheme()
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().backgroundColor = UIColor(white: 1, alpha: 0.25)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(named: "AccentColor")!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appContext.splashScreenPresented {
                    SplashScreen(token: token)
                } else {
                    ContentView()
                }
            }
            .onChange(of: appContext.isLoggedIn) { value in
                token = value ? appContext.credentials?.token ?? "" : ""
            }
        }
    }
}
