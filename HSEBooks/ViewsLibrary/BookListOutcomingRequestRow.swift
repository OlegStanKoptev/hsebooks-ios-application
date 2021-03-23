//
//  BookListOutcomingRequestRow.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct BookListOutcomingRequestRow: View {
    enum Status {
        case hold, completed, inProgress
    }
    let title: String
    let author: String
    let username: String
    let city: String
    let date: String
    let status: Status
    var body: some View {
        BookListRowBase(title: title, author: author, height: 120, trailingPadding: 0) {
//            VStack(alignment: .leading, spacing: 4) {
//                HStack(spacing: 4) {
//                    Text("Request from:")
//                        .foregroundColor(Color("Orange"))
//                    Text(username)
//                        .foregroundColor(.primary)
//                }
//                HStack {
//                    Image(systemName: "pin.fill")
//                        .foregroundColor(Color("Orange"))
//                    Text("\(city)")
//                        .foregroundColor(.primary)
//                }
//            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "pin.fill")
                        .foregroundColor(Color("Orange"))
                    Text("\(city)")
                }
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(Color("AccentColor"))
                    Text("\(username)")
                }
            }
            .foregroundColor(Color(.lightGray))
        }
        .overlay(
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    Group {
                        if status == .hold {
                            NavigationLink(
                                destination: Text("Destination"),
                                label: {
                                    Text("Chat")
                                })
                                .buttonStyle(FilledRoundedButtonStyle(fillColor: Color("AccentColor")))
                            Button(action: {}, label: {
                                Text("Hold")
                            })
                            .buttonStyle(RoundedButtonStyle(color: .red))
                            .disabled(true)
                        } else if status == .inProgress {
                            NavigationLink(
                                destination: Text("Destination"),
                                label: {
                                    Text("Chat")
                                })
                                .buttonStyle(FilledRoundedButtonStyle(fillColor: Color("AccentColor")))
                            Button(action: {}, label: {
                                Text("In Progress")
                            })
                            .buttonStyle(RoundedButtonStyle(color: .green))
                            .disabled(true)
                        } else if status == .completed {
                            NavigationLink(
                                destination: Text("Destination"),
                                label: {
                                    Text("Chat")
                                })
                                .buttonStyle(FilledRoundedButtonStyle(fillColor: .gray))
                            Button(action: {}, label: {
                                Text("Completed")
                            })
                            .buttonStyle(RoundedButtonStyle(color: Color("AccentColor")))
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

struct BookListRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookListOutcomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .hold)
            BookListOutcomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .inProgress)
            BookListOutcomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .completed)
        }
            .previewLayout(.sizeThatFits)
    }
}
