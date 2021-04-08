//
//  RequestService.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 03.04.2021.
//

import Foundation

class RequestService {
    
    enum RequestError: Error {
        case client(Error)
        case server(HTTPURLResponse)
        case expiredToken
    }
    
    static let shared = RequestService()
    private let session: URLSession
    private let decoder: JSONDecoder
    private let serverUrl = URL(string: "http://192.168.1.18")!
    
    private init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func makeRequest(to endpoint: String, with params: [String: String], using authService: AuthorizationService? = nil, handler: @escaping (Result<Data, RequestError>, JSONDecoder) -> Void) {
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
        
        if let authService = authService {
            request.setValue(authService.authToken, forHTTPHeaderField: "Authorization")
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(.client(error)), self.decoder)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                fatalError("Reponse couldn't be casted to HTTPURLResponse, I have no idea why...")
            }
            if (200...299).contains(httpResponse.statusCode) {
                if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                   let data = data {
                    handler(.success(data), self.decoder)
                }
            } else if httpResponse.statusCode == 403 {
                handler(.failure(.expiredToken), self.decoder)
            } else {
                handler(.failure(.server(httpResponse)), self.decoder)
            }
            
        }.resume()
        
    }
    
    func makeAuthRequest(to endpoint: String, with body: [String: String], handler: @escaping (String, Data?, JSONDecoder) -> Void) {
        let jsonBody = "{ \(body.map{ "\"\($0.key)\": \"\($0.value)\"" }.joined(separator: ", ")) }"
        let endpointUrl = serverUrl.appendingPathComponent(endpoint)
        var request = URLRequest(url: endpointUrl)
        request.httpBody = jsonBody.data(using: .utf8)
        request.httpMethod = "POST"
        
        session.dataTask(with: request) { data, response, error in
            if let _ = error {
                handler("", nil, self.decoder)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                handler("", nil, self.decoder)
                return
            }
            if let authToken = httpResponse.value(forHTTPHeaderField: "Authorization"),
               let data = data {
                handler(authToken, data, self.decoder)
            }
        }.resume()
    }
}
