//
//  AuthPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct AuthPage: View {
    @EnvironmentObject var authData: AuthData
    @State var username: String = "Keker"//"OlegStan"
    @State var password: String = "1234"//"superSecret"
    
    func login() {
        authData.login(username: username, password: password)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                VStack {
                    TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password) { login() }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                Button(action: { login() }) {
                    Text("Log In")
                }
                
                NavigationLink(destination: SignUpPage()) {
                    Text("Sign Up")
                }
                
                Spacer()
            }
            .disabled(authData.authState == .loading)
            .overlay(
                StatusOverlay(viewState: $authData.authState)
            )
            .navigationTitle("Log In")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SignUpPage: View {
    @EnvironmentObject var authData: AuthData
    @State var name: String = "Default Name"
    @State var username: String = "NewUser"
    @State var password: String = "1234"
    
    func signup() {
        authData.signup(name: name, username: username, password: password)
    }
    
    
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                TextField("Name", text: $name)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                TextField("Username", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                SecureField("Password", text: $password) { signup() }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Button(action: { signup() }) {
                Text("Sign Up")
            }
            
            Spacer()
        }
        .disabled(authData.authState == .loading)
        .overlay(
            StatusOverlay(viewState: $authData.authState)
        )
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AuthPage_Previews: PreviewProvider {
    static var previews: some View {
        AuthPage()
            .environmentObject(AuthData.preview)
    }
}
