//
//  AuthPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct AuthPage: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var auth: AuthData
    @State var username: String = "Keker"//"OlegStan"
    @State var password: String = "1234"//"superSecret"
    var body: some View {
        VStack {
            VStack {
                TextField("Username", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                SecureField("Password", text: $password) {
                    auth.login(with: username, and: password)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Button(action: {
                auth.login(with: username, and: password)
            }) {
                Text("Log In")
            }
            
            Spacer()
        }
        .onChange(of: auth.authStep, perform: { value in
            if value == .success {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .disabled(auth.authStep == .loading)
        .overlay(
            Group {
                switch auth.authStep {
                case .none, .success:
                    EmptyView()
                case .loading:
                    SpinnerView()
                case .failure(let message):
                    TextOverlay(text: message)
                }
            }
        )
    }
}

struct AuthPage_Previews: PreviewProvider {
    static var previews: some View {
        AuthPage()
            .environmentObject(AuthData.preview)
    }
}
