//
//  BookListOutcomingRequestRow.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

enum BookListOutcomingRequestRowStatus {
    case hold, completed, inProgress
}

struct BookListOutcomingRequestRow<Destination: View>: View {
    typealias Status = BookListOutcomingRequestRowStatus
    
    let title: String
    let author: String
    let username: String
    let city: String
    let date: String
    let status: Status
    let destination: Destination
    var body: some View {
        BookListRowBase(title: title, author: author, height: 120, trailingPadding: 0) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.accentColor)
                    Text("\(city)")
                }
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(Color("SecondColor"))
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
                                destination: destination,
                                label: {
                                    Text("Chat")
                                })
                                .buttonStyle(FilledRoundedButtonStyle(fillColor: Color("SecondColor")))
                            Button(action: {}, label: {
                                Text("Hold")
                            })
                            .buttonStyle(RoundedButtonStyle(color: .red))
                            .disabled(true)
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

struct BookListRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookListOutcomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .hold, destination: Text("dest"))
            BookListOutcomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .inProgress, destination: Text("dest"))
            BookListOutcomingRequestRow(title: "title", author: "author", username: "leon", city: "moscow", date: "21.02.2021", status: .completed, destination: Text("dest"))
        }
            .previewLayout(.sizeThatFits)
    }
}
