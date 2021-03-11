//
//  ProfileView.swift
//  BookExchange
//
//  Created by Oleg Koptev on 11.03.2021.
//

import SwiftUI

struct ProfileView: View {
    @State var username: String = ""
    @State var password: String = ""
    let accentColor = Color(hue: 0.6, saturation: 1, brightness: 0.7)
    var body: some View {
        VStack {
            Text("Authorization")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.vertical, 8)
            ZStack {
                Image("ScreenBackground")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width)
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.15)
                
                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 24) {
                            VStack {
                                TextField("Username", text: $username)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding(.horizontal, 8)
                                RoundedRectangle(cornerRadius: 2)
                                    .foregroundColor(accentColor)
                                    .frame(height: 2)
                                    
                            }
                            VStack {
                                SecureField("Password", text: $password)
                                    .padding(.horizontal, 8)
                                RoundedRectangle(cornerRadius: 2)
                                    .foregroundColor(accentColor)
                                    .frame(height: 2)
                            }
                            
                            Button(action: {}, label: {
                                HStack {
                                    Spacer()
                                    Text("Log In")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(accentColor)
                                )
                            })
                            Button(action: {}, label: {
                                Text("Forgot password?")
                                    .underline()
                                    .foregroundColor(.secondary)
                            })
                            Button(action: {}, label: {
                                HStack {
                                    Spacer()
                                    Text("Sign Up")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(.orange)
                                )
                            })
                        }
                        .padding(.vertical, 12)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(Color(.systemGray6))
                            .shadow(radius: 2, y: 2)
                    )
                    .padding(.horizontal)
                    .padding(.top, 16)
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .backgroundForNavBar(height: 44)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
