//
//  Profile.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 15.03.2021.
//

import SwiftUI

struct Profile: View {
//    @EnvironmentObject var tabBarContext: TabBarContext
    @Binding var currentTab: ContentView.Tab
    @State private var authorized: Bool = false
    @State private var authPagePresented: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Profile", backButtonHidden: true)
                .padding(.vertical, 4)
                .navigationBarBackgroundStyle()
            
            Spacer(minLength: 0)
            
            if authorized {
                ProfileMenu(
                    currentTab: $currentTab,
                    logOutAction: {
                        authorized = false
                    }
                )
            } else {
                VStack {
                    Text("Authorize to request books or \nto give them away.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .font(.system(size: 18))
                    Button(action: { authPagePresented = true }) {
                        Text("Authorize")
                    }
                    .buttonStyle(FilledRoundedButtonStyle(fillColor: .accentColor, verticalPadding: 24))
                    .accentColor(.orange)
                    .padding(.horizontal, 32)
                }
                .padding(.horizontal, 24)
            }
            
            Spacer(minLength: 0)
        }
        .sheet(isPresented: $authPagePresented, onDismiss: {}, content: {
            AuthScreen(presented: $authPagePresented) { result in
                authorized = result == .success
            }
        })
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(currentTab: .constant(.profile))
            .accentColor(Color("Orange"))
//            .environmentObject(TabBarContext())
    }
}
