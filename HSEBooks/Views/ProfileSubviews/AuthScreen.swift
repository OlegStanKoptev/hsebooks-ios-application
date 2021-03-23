//
//  AuthScreen.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 15.03.2021.
//

import SwiftUI

struct AuthScreen: View {
    @Binding var authorized: Bool
    var presented: Binding<Bool>?
    func handleLogIn(username: String, password: String) -> Bool {
        presented?.wrappedValue = false
        authorized = true
        return true
    }
    
    func handleSignUp() {
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Authorization", backButtonHidden: true)
                .overlay(
                    HStack {
                        Button("Close", action: {
                            presented?.wrappedValue = false
                        })
                        .foregroundColor(.orange)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                )
                .padding(.vertical, 8)
                .navigationBarBackgroundStyle()
            LogInView {
                handleLogIn(username: $0, password: $1)
            } onSignupPressed: {
                handleSignUp()
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(4)
            .shadow(radius: 4, y: 2)
            .padding()
            
            Spacer(minLength: 0)
            
            GeometryReader { geo in
                Image("ScreenBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.bottom)
                    .opacity(0.25)
            }
        }
    }
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen(authorized: .constant(false))
    }
}
