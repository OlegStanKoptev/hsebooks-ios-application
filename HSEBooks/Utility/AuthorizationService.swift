//
//  AuthorizationService.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 03.04.2021.
//

import Foundation

class AuthorizationService {
    static let shared = AuthorizationService()
    private(set) var currentUser: User?
    private(set) var authToken: String?
    private(set) var errorMessage: String?
    
    private init(user: User = User.defaultAdminUser) {
        // logIn(with: user.username, and: "superSecret")
        mockLogIn(with: user)
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    func mockLogIn(with user: User) {
        currentUser = user
        authToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJPbGVnU3RhbiIsImV4cCI6MTYxODcwMDI2Nn0.xsDVhQdGtdrXLdVh120Ft9qP7Al34JSlzfnCJeZ-zznvOsU966G74Ewn70O6OSPfFRqtLWH5PNGivn95Vpe_Bg"
    }
    
    func logIn(with username: String, and password: String) {
        let body = [
            "username": username,
            "password": password
        ]
        RequestService.shared.makeAuthRequest(to: "login", with: body) { newToken, data, decoder in
            if let data = data,
               !newToken.isEmpty {
                do {
                    print(newToken)
                    self.authToken = newToken
                    self.currentUser = try decoder.decode(User.self, from: data)
                    self.errorMessage = nil
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            } else {
                self.errorMessage = "Couldn't log in, probably wrong log in details"
            }
        }
    }
}
