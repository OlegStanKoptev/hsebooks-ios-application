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
        appContext.getSettingsValues()
        UINavigationBar.setupAppColorTheme()
        UISegmentedControl.setupAppColorTheme()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appContext.splashScreenPresented {
                    SplashScreen(token: token)
                } else if !appContext.isLoggedIn {
                    AuthPage()
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
