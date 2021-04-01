//
//  LogInView.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct LogInView: View {
    @State var username: String = ""
    @State var password: String = ""
    var onLoginPressed: ((String, String) -> Bool)?
    var onSignupPressed: (() -> Void)?
    
    private let accentColor = Color(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1))
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 2) {
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 8)
                    .frame(height: UIFont.preferredFont(forTextStyle: .body).lineHeight)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(height: 2)
            }
            .padding(.bottom, 12)
            
            VStack(spacing: 2) {
                SecureField("Password", text: $password)
                    .padding(.horizontal, 8)
                    .frame(height: UIFont.preferredFont(forTextStyle: .body).lineHeight)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(height: 2)
            }
            .padding(.bottom, 12)
            
            Button(action: {
                if onLoginPressed?(username, password) ?? false {
                    username = ""
                    password = ""
                }
            }, label: {
                Text("Log In")
            })
            .buttonStyle(FilledRoundedButtonStyle(fillColor: accentColor, verticalPadding: 32))
            
            Button(action: { onSignupPressed?() }, label: {
                Text("Sign Up")
            })
            .buttonStyle(FilledRoundedButtonStyle(fillColor: .accentColor, verticalPadding: 32))
        }
        .padding(.vertical, 36)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
