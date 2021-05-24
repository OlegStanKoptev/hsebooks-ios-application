//
//  AuthPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct AuthPage: View {
    @ObservedObject var appContext = AppContext.shared
    @State private var username: String = ""//"Ivanov"//"OlegStan"
    @State private var password: String = ""//"1234"//"superSecret"
    
    func login() {
        appContext.login(username: username, password: password)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        VStack(spacing: 2) {
                            TextField("Username", text: $username)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.horizontal, 8)
                                .frame(height: UIFont.preferredFont(forTextStyle: .body).lineHeight)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.tertiaryColor)
                                .frame(height: 2)
                        }
                        .padding(.bottom, 4)

                        VStack(spacing: 2) {
                            SecureField("Password", text: $password)
                                .padding(.horizontal, 8)
                                .frame(height: UIFont.preferredFont(forTextStyle: .body).lineHeight)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.tertiaryColor)
                                .frame(height: 2)
                        }
                    }
                    .padding(.bottom, 16)

                    VStack(spacing: 16) {
                        Button(action: { login() }, label: {
                            Text("Log In")
                        })
                        .buttonStyle(FilledRoundedButtonStyle(fillColor: .tertiaryColor, verticalPadding: 16))

                        NavigationLink(destination: SignUpPage()) {
                            Text("Sign Up")
                        }
                        .buttonStyle(FilledRoundedButtonStyle(verticalPadding: 16))
                    }
                }
                .disabled(appContext.authViewState == .loading)
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
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
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Menu("Test Auth") {
                        Button("Ivanov", action: {
                            appContext.login(username: "Ivanov", password: "1234")
                        })
                        
                        Button("Petrov", action: {
                            appContext.login(username: "Petrov", password: "1234")
                        })
                    }
                }
            }
            .overlay(StatusOverlay(viewState: $appContext.authViewState))
            .navigationTitle("Authorization")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SignUpPage: View {
    @ObservedObject var appContext = AppContext.shared
    @State private var name: String = ""//"Default Name"
    @State private var username: String = ""//"NewUser\(Int.random(in: 100..<999))"
    @State private var password: String = ""//"1234"
    
    func signup() {
        appContext.signup(name: name, username: username, password: password)
    }
    
    
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                VStack(spacing: 2) {
                    TextField("Name", text: $name)
                        .padding(.horizontal, 8)
                        .frame(height: UIFont.preferredFont(forTextStyle: .body).lineHeight)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.tertiaryColor)
                        .frame(height: 2)
                }
                .padding(.bottom, 4)
                
                VStack(spacing: 2) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 8)
                        .frame(height: UIFont.preferredFont(forTextStyle: .body).lineHeight)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.tertiaryColor)
                        .frame(height: 2)
                }
                .padding(.bottom, 4)

                VStack(spacing: 2) {
                    SecureField("Password", text: $password)
                        .padding(.horizontal, 8)
                        .frame(height: UIFont.preferredFont(forTextStyle: .body).lineHeight)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.tertiaryColor)
                        .frame(height: 2)
                }
                .padding(.bottom, 16)

                Button(action: { signup() }, label: {
                    Text("Sign Up")
                })
                .buttonStyle(FilledRoundedButtonStyle(verticalPadding: 16))
            }
            .disabled(appContext.authViewState == .loading)
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
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
        .overlay(StatusOverlay(viewState: $appContext.authViewState))
        .navigationTitle("Registration")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AuthPage_Previews: PreviewProvider {
    static var previews: some View {
        AuthPage()
            .environmentObject(AppContext.preview)
    }
}
