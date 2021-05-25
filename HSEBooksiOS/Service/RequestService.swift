//
//  RequestService.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 24.04.2021.
//

import Foundation

enum RequestError: Error {
    case client(Error)
    case server(HTTPURLResponse)
    case expiredToken
    case notAuthorized
    case other(String)
    
    var description: String {
        switch self {
        case .client(let error): return "Client: \(error)"
        case .server(let response): return "Server error \(response.statusCode)"
        case .expiredToken: return "Expired Bearer Token"
        case .notAuthorized: return "Not Logged In"
        case .other(let value): return "\(value)"
        }
    }
}

class RequestService {
    static let shared: RequestService = RequestService()
    static func configure(serverUrl: URL) {
        shared.serverUrl = serverUrl
    }
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    var serverUrl: URL!
    
    private init(session: URLSession = .shared, decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func makeRequest<T: Decodable>(to endpoint: String, method: String = "GET", with params: [String: String] = [:], using authToken: String, handler: @escaping (Result<T, RequestError>) -> Void) {
        guard
            var urlComponents =
                URLComponents(
                    url: serverUrl.appendingPathComponent(endpoint),
                    resolvingAgainstBaseURL: false
                )
        else { preconditionFailure("Can't create url components...") }
        
        urlComponents.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard
            let url = urlComponents.url
        else { preconditionFailure("Can't create url from url components...") }
        
        var request = URLRequest(url: url)
        
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = method
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                        handler(.failure(.client(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
                }
                if (200...299).contains(httpResponse.statusCode),
                    let mimeType = httpResponse.mimeType, mimeType == "application/json",
                    let data = data {
                        do {
                            if let self = self {
                                handler(.success(try self.decoder.decode(T.self, from: data)))
                            } else {
                                handler(.failure(.other("RequestService is nil")))
                            }
                        } catch {
                            handler(.failure(.client(error)))
                        }
                } else if httpResponse.statusCode == 401 {
                    handler(.failure(.expiredToken))
                } else {
                    handler(.failure(.server(httpResponse)))
                }
            }
        }.resume()
        
    }
    
    func makeAuthRequest(to endpoint: String, with body: [String: String], handler: @escaping (Result<(User, String), RequestError>) -> Void) {
        let jsonBody = try! encoder.encode(body)
        let endpointUrl = serverUrl.appendingPathComponent(endpoint)
        var request = URLRequest(url: endpointUrl)
        request.httpBody = jsonBody
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "POST"
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    handler(.failure(.client(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
                }
                if let data = data {
                    if let authToken = httpResponse.value(forHTTPHeaderField: "Authorization"),
                       (200...299).contains(httpResponse.statusCode) {
                        do {
                            if let self = self {
                                handler(.success((try self.decoder.decode(User.self, from: data), authToken)))
                            } else {
                                handler(.failure(.other("RequestService is nil")))
                            }
                        } catch {
                            self?.makeRequest(to: "user/me", with: [:], using: authToken) { (result: Result<User, RequestError>) in
                                switch result {
                                case .failure(let error):
                                    handler(.failure(error))
                                case .success(let user):
                                    handler(.success((user, authToken)))
                                }
                            }
                        }
                    } else if let data = String(data: data, encoding: .utf8),
                              httpResponse.statusCode == 403 {
                        handler(.failure(.other(data)))
                    } else {
                        handler(.failure(.other("Wrong username or password.")))
                    }
                } else {
                    handler(.failure(.server(httpResponse)))
                }
            }
        }.resume()
    }
    
    func makePostRequest<T: Decodable, U: Encodable>(to endpoint: String, with authToken: String, body: U, params: [String: String] = [:], handler: @escaping (Result<T, RequestError>) -> Void) {
        let jsonBody = try! encoder.encode(body)
        guard
            var urlComponents =
                URLComponents(
                    url: serverUrl.appendingPathComponent(endpoint),
                    resolvingAgainstBaseURL: false
                )
        else { preconditionFailure("Can't create url components...") }
        
        urlComponents.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard
            let url = urlComponents.url
        else { preconditionFailure("Can't create url from url components...") }
        
        var request = URLRequest(url: url)
        
        request.httpBody = jsonBody
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "POST"
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    handler(.failure(.client(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
                }
                if let data = data {
                    if (200...299).contains(httpResponse.statusCode) {
                        do {
                            if let self = self {
                                handler(.success(try self.decoder.decode(T.self, from: data)))
                            } else {
                                handler(.failure(.other("RequestService is nil")))
                            }
                        } catch {}
                    } else if let data = String(data: data, encoding: .utf8) {
                        handler(.failure(.other(data)))
                    } else if httpResponse.statusCode == 403 {
                        handler(.failure(.notAuthorized))
                    } else {
                        handler(.failure(.server(httpResponse)))
                    }
                } else {
                    handler(.failure(.server(httpResponse)))
                }
            }
        }.resume()
    }
    
    func makeRequestWithoutResponse(to endpoint: String, authToken: String, method: String, params: [String: String], handler: @escaping (Result<Void, RequestError>) -> Void) {
        guard
            var urlComponents =
                URLComponents(
                    url: serverUrl.appendingPathComponent(endpoint),
                    resolvingAgainstBaseURL: false
                )
        else { preconditionFailure("Can't create url components...") }
        
        urlComponents.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard
            let url = urlComponents.url
        else { preconditionFailure("Can't create url from url components...") }
        
        var request = URLRequest(url: url)
        
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = method
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    handler(.failure(.client(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
                }
                if (200...299).contains(httpResponse.statusCode) {
                    handler(.success(()))
                } else if httpResponse.statusCode == 403 {
                    handler(.failure(.notAuthorized))
                } else {
                    handler(.failure(.server(httpResponse)))
                }
            }
        }.resume()
    }
    
//    func makeDeleteRequest(to endpoint: String, authToken: String, params: [String: String], handler: @escaping (Result<Void, RequestError>) -> Void) {
//        guard
//            var urlComponents =
//                URLComponents(
//                    url: serverUrl.appendingPathComponent(endpoint),
//                    resolvingAgainstBaseURL: false
//                )
//        else { preconditionFailure("Can't create url components...") }
//
//        urlComponents.queryItems = params.map {
//            URLQueryItem(name: $0.key, value: $0.value)
//        }
//
//        guard
//            let url = urlComponents.url
//        else { preconditionFailure("Can't create url from url components...") }
//
//        var request = URLRequest(url: url)
//
//        request.setValue(authToken, forHTTPHeaderField: "Authorization")
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
//        request.httpMethod = "DELETE"
//
//        session.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async { [weak self] in
//                if let error = error {
//                    handler(.failure(.client(error)))
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
//                }
//                if (200...299).contains(httpResponse.statusCode) {
//                    handler(.success(()))
//                } else if httpResponse.statusCode == 403 {
//                    handler(.failure(.notAuthorized))
//                } else {
//                    handler(.failure(.server(httpResponse)))
//                }
//            }
//        }.resume()
//    }
    
    func makePutRequest<T: Decodable, U: Encodable>(to endpoint: String, with authToken: String, body: U, params: [String: String] = [:], handler: @escaping (Result<T, RequestError>) -> Void) {
        let jsonBody = try! encoder.encode(body)
        guard
            var urlComponents =
                URLComponents(
                    url: serverUrl.appendingPathComponent(endpoint),
                    resolvingAgainstBaseURL: false
                )
        else { preconditionFailure("Can't create url components...") }
        
        urlComponents.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard
            let url = urlComponents.url
        else { preconditionFailure("Can't create url from url components...") }
        
        var request = URLRequest(url: url)
        
        request.httpBody = jsonBody
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "PUT"
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    handler(.failure(.client(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
                }
                guard let data = data  else { handler(.failure(.other("Data is null"))); return }
                if (200...299).contains(httpResponse.statusCode) {
                    do {
                        if let self = self {
                            handler(.success(try self.decoder.decode(T.self, from: data)))
                        } else {
                            handler(.failure(.other("RequestService is nil")))
                        }
                    } catch {}
                } else if httpResponse.statusCode == 403 {
                    if let body = String(data: data, encoding: .utf8) {
                        handler(.failure(.other(body)))
                    } else {
                        handler(.failure(.notAuthorized))
                    }
                } else {
                    handler(.failure(.server(httpResponse)))
                }
            }
        }.resume()
    }
    
    func makePatchRequest<T: Decodable>(to endpoint: String, with authToken: String, handler: @escaping (Result<T, RequestError>) -> Void) {
        self.makeRequest(to: endpoint, method: "PATCH", using: authToken, handler: handler)
    }
}
