//
//  Requests.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 23.03.2021.
//

import SwiftUI

struct Requests: View {
    enum Page: String, CaseIterable {
        case incoming = "Incoming"
        case outcoming = "Outcoming"
    }
    
    @State var currentPage: Page = .incoming
    @State var incomingRequests: [IncomingRequestsList.Request] = [
        .init(status: .pending),
        .init(status: .inProgress),
        .init(status: .inProgress),
        .init(status: .completed),
    ]
    @State var outcomingRequests: [OutcomingRequestsList.Request] = [
        .init(status: .hold),
        .init(status: .completed),
        .init(status: .inProgress),
        .init(status: .inProgress),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Requests")
                .padding(.vertical, 8)
                .navigationBarBackgroundStyle()
            
            HStack(spacing: 0) {
                ForEach(Page.allCases, id: \.self) { page in
                    Button(action: {
                        currentPage = page
                    }) {
                        Rectangle()
                            .fill(
                                currentPage == page ?
                                    Color.white :
                                    Color("AccentColor").opacity(0.75)
                            )
                            .overlay(
                                Text(page.rawValue)
                                    .textCase(.uppercase)
                                    .foregroundColor(
                                        currentPage == page ?
                                            Color("Orange") :
                                            .white
                                    )
                            )
                    }
                    .buttonStyle(SlightlyPressedButtonStyle())
                }
            }
            .frame(height: UIFont.preferredFont(forTextStyle: .body).pointSize + 24)
            
            Rectangle()
                .fill(Color("AccentColor"))
                .frame(height: 0.5)
            
            Group {
                switch currentPage {
                case .incoming:
                    IncomingRequestsList(requests: $incomingRequests)
                case .outcoming:
                    OutcomingRequestsList(requests: $outcomingRequests)
                }
            }
            
            Spacer(minLength: 0)
        }
        .navigationBarHidden(true)
    }
}

struct Requests_Previews: PreviewProvider {
    static var previews: some View {
        Requests()
    }
}
