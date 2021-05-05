//
//  NotificationsPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 05.05.2021.
//

import SwiftUI

struct NotificationsPage: View {
    @State var notifications: [Notification] = []
    var body: some View {
        List(notifications) { notification in
            VStack(alignment: .leading) {
                Text(notification.header)
                    .font(.headline)
                Text(notification.body)
                    .font(.body)
            }
        }
        .navigationTitle("Notifications")
    }
}

extension NotificationsPage {
    struct Notification: RemoteEntity {
        var id: Int
        var header: String
        var body: String
        
        static func getItems(amount: Int) -> [NotificationsPage.Notification] {
            var result = [Self]()
            for i in 0..<amount {
                result.append(
                    Self.init(id: i, header: "Header \(i)", body: "Body \(i)")
                )
            }
            return result
        }
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage(notifications: NotificationsPage.Notification.getItems(amount: 5))
    }
}
