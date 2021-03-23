//
//  IncomingRequestsList.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 23.03.2021.
//

import SwiftUI

struct IncomingRequestsList: View {
    struct Request: Identifiable {
        let id: UUID = UUID()
        var title: String = "Title"
        var author: String = "Author"
        var username: String = "User name"
        var city: String = "City"
        var date: String = "01.01.1970"
        var status: BookListIncomingRequestRow.Status = .pending
    }
    
    @Binding var requests: [Request]
        
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ForEach(requests) { request in
                    BookListIncomingRequestRow(
                        title: request.title,
                        author: request.author,
                        username: request.username,
                        city: request.city,
                        date: request.date,
                        status: request.status,
                        onAccept: {
                            
                        },
                        onDecline: {
                            
                        }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct IncomingRequests_Previews: PreviewProvider {
    static let requests: [IncomingRequestsList.Request] = [
        .init(status: .pending),
        .init(status: .inProgress),
        .init(status: .inProgress),
        .init(status: .completed),
    ]
    static var previews: some View {
        IncomingRequestsList(requests: .constant(requests))
    }
}
