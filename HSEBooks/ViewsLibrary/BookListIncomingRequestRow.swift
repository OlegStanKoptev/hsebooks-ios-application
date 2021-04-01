//
//  BookListIncomingRequestRow.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

enum BookListIncomingRequestRowStatus {
    case completed, inProgress, pending
}

struct BookListIncomingRequestRow<Destination: View>: View {
    typealias Status = BookListIncomingRequestRowStatus
    
    let title: String
    let author: String
    let username: String
    let city: String
    let date: String
    let status: Status
    let destination: Destination
    var onAccept: (() -> Void)?
    var onDecline: (() -> Void)?
    var body: some View {
        BookListRowBase(title: title, author: author, height: 120, trailingPadding: 0) {            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text("Request from:")
                        .foregroundColor(.accentColor)
                    Text(username)
                        .foregroundColor(.primary)
                }
                HStack {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.accentColor)
                    Text("\(city)")
                        .foregroundColor(.primary)
                }
            }
        }
        .overlay(
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    Group {
                        if status == .pending {
                            Button(action: { onAccept?() }, label: {
                                Text("Accept")
                            })
                            .buttonStyle(FilledRoundedButtonStyle(fillColor: Color("SecondColor")))
                            Button(action: { onDecline?() }, label: {
                                Text("Decline")
                            })
                            .buttonStyle(FilledRoundedButtonStyle(fillColor: .accentColor))
                        } else if status == .inProgress {
                            NavigationLink(
                                destination: destination,
                                label: {
                                    Text("Chat")
                                })
                            .buttonStyle(FilledRoundedButtonStyle(fillColor: Color("SecondColor")))
                            Button(action: {}, label: {
                                Text("In Progress")
                            })
                            .buttonStyle(RoundedButtonStyle(color: .green))
                            .disabled(true)
                        } else if status == .completed {
                            NavigationLink(
                                destination: destination,
                                label: {
                                    Text("Chat")
                                })
                            .buttonStyle(FilledRoundedButtonStyle(fillColor: .gray))
                            Button(action: {}, label: {
                                Text("Completed")
                            })
                            .buttonStyle(RoundedButtonStyle(color: Color("SecondColor")))
                            .disabled(true)
                        }
                    }
                    .lineLimit(1)
                    .frame(width: 88)
                    Text(date)
                        .foregroundColor(Color(.lightGray))
                        .font(.system(size: 15))
                        .padding(.trailing, 3)
                }
                .padding(.trailing, 12)
            }
        )
    }
}

struct BookListIncomingRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookListIncomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .pending, destination: Text("dest"))
            BookListIncomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .inProgress, destination: Text("dest"))
            BookListIncomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .completed, destination: Text("dest"))
        }
        .previewLayout(.sizeThatFits)
    }
}
