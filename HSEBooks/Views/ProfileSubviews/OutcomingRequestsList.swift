//
//  OutcomingRequestsList.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 23.03.2021.
//

import SwiftUI

struct OutcomingRequestsList: View {
    struct Request: Identifiable {
        let id = UUID()
        var title: String = "Title"
        var author: String = "Author"
        var username: String = "User name"
        var city: String = "City"
        var date: String = "01.01.1970"
        var status: BookListOutcomingRequestRow.Status = .hold
    }
    
    @Binding var requests: [Request]
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ForEach(requests) { request in
                    BookListOutcomingRequestRow(title: request.title, author: request.author, username: request.username, city: request.city, date: request.date, status: request.status, destination: Chat())
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct MyRequestsList_Previews: PreviewProvider {
    static let requests: [OutcomingRequestsList.Request] = [
        .init(status: .hold),
        .init(status: .completed),
        .init(status: .inProgress),
        .init(status: .inProgress),
    ]
    static var previews: some View {
        OutcomingRequestsList(requests: .constant(requests))
    }
}
