//
//  AuthData.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 23.04.2021.
//

import Foundation
import SwiftUI

class AuthData: ObservableObject {
    @Published var currentUser: User?
    @Published var token: String?
    @Published var authStep: AuthStep = .none
    var isPreview: Bool = false
    
    enum AuthStep: Equatable {
        case none
        case loading
        case success
        case failure(String)
    }
    
    var isLoggedIn: Bool {
        currentUser != nil && token != nil
    }
    
    static let preview: AuthData = {
        let auth = AuthData()
        auth.isPreview = true
        auth.currentUser = .default
        auth.token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJPbGVnU3RhbiIsImV4cCI6MTYyMDA1ODQ0OH0.7jxLKa-FFQOrC9Ua5M5CeBA5mj9ucXSVSO5_Yde9bg6z6H9nNw6t-pr8xDRf5EM_ST9v9py-CUumSgiItnHm5A"
        return auth
    }()
    
    private func authRequest(to endpoint: String, with body: [String: String]) {
        guard !isPreview else { return }
        authStep = .loading
        RequestService.shared.makeAuthRequest(to: endpoint, with: body) { (result: Result<(User, String), RequestService.RequestError>) in
            switch result {
            case .failure(let error):
                    self.authStep = .failure(error.description)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.authStep = .none
                    }
            case .success(let (user, token)):
                    self.currentUser = user
                    self.token = token
                    self.authStep = .success
            }
        }
    }
    
    func login(with username: String, and password: String) {
        authRequest(
            to: User.login.endpoint,
            with: [ "username": username, "password": password ]
        )
    }
    
    func signup(with name: String, and username: String, and password: String) {
        authRequest(
            to: User.signup.endpoint,
            with: [ "username": username, "password": password, "name": name ]
        )
    }
}
