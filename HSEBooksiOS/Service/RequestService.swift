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
    static let shared = RequestService()
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let serverUrl = URL(string: "http://olegk.site")!
    
    private init(session: URLSession = .shared, decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func makeRequest<T: Decodable>(to endpoint: String, with params: [String: String] = [:], using authToken: String, handler: @escaping (Result<T, RequestError>) -> Void) {
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
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
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
                            handler(.success(try self.decoder.decode(T.self, from: data)))
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
    
    func makeAuthRequest<T: Decodable>(to endpoint: String, with body: [String: String], handler: @escaping (Result<(T, String), RequestError>) -> Void) {
        let jsonBody = try! encoder.encode(body)
        let endpointUrl = serverUrl.appendingPathComponent(endpoint)
        var request = URLRequest(url: endpointUrl)
        request.httpBody = jsonBody
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "POST"
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    handler(.failure(.client(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
                }
                if (200...299).contains(httpResponse.statusCode),
                   let authToken = httpResponse.value(forHTTPHeaderField: "Authorization"),
                   let data = data {
                        do {
                            handler(.success((try self.decoder.decode(T.self, from: data), authToken)))
                        } catch {
                            self.makeRequest(to: "user/me", with: [:], using: authToken) { (result: Result<T, RequestError>) in
                                switch result {
                                case .failure(let error):
                                    handler(.failure(error))
                                case .success(let user):
                                    handler(.success((user, authToken)))
                                }
                            }
                        }
                } else if httpResponse.statusCode == 403 {
                    handler(.failure(.notAuthorized))
                } else {
                    handler(.failure(.server(httpResponse)))
                }
            }
        }.resume()
    }
    
    func someFunc() -> Result<String, RequestError> {
        
        
//        return .success("String type")
        return .failure(RequestError.notAuthorized)
    }
}
