//
//  BookListOutcomingRequestRow.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

struct BookListOutcomingRequestRow<Destination: View>: View {
    let title: String
    let author: String
    let photoId: Int?
    let name: String
    let city: String
    let date: String
    let status: RequestStatus
    let destination: Destination
    var body: some View {
        BookListRow(
            title: title,
            author: author,
            photoId: photoId,
            coverType: .bookPhoto,
            trailingPadding: 32,
            thirdLine:
                HStack {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.accentColor)
                    Text("\(city)")
                },
            fourthLine:
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(Color.tertiaryColor)
                    Text("\(name)")
                }
        )
        .overlay(
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    Group {
                        if status == .Pending {
                            NavigationLink(
                                destination: destination,
                                label: {
                                    Text("Chat")
                                })
                                .buttonStyle(FilledRoundedButtonStyle(fillColor: Color.tertiaryColor))
                            Button(action: {}, label: {
                                Text("Pending")
                            })
                            .buttonStyle(RoundedButtonStyle(color: .yellow))
                            .disabled(true)
                        } else if status == .Rejected {
                            NavigationLink(
                                destination: destination,
                                label: {
                                    Text("Chat")
                                }
                            )
                            .buttonStyle(FilledRoundedButtonStyle(fillColor: Color.tertiaryColor))
//                            .disabled(true)
                            
                            Button(action: {}, label: {
                                Text("Declined")
                            })
                            .buttonStyle(RoundedButtonStyle(color: .red))
                            .disabled(true)
                        } else if status == .Accepted {
                            NavigationLink(
                                destination: destination,
                                label: {
                                    Text("Chat")
                                }
                            )
                            .buttonStyle(FilledRoundedButtonStyle(fillColor: Color.tertiaryColor))
//                            .disabled(true)
                            
                            Button(action: {}, label: {
                                Text("Completed")
                            })
                            .buttonStyle(RoundedButtonStyle(color: Color.green))
                            .disabled(true)
                        }
                    }
                    .lineLimit(1)
                    .frame(width: 88)
                    Text(date.asDate)
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
            BookListOutcomingRequestRow(title: "title", author: "author", photoId: nil, name: "leon", city: "moscow", date: "2021-05-06T20:15:55.724+00:00", status: .Pending, destination: Text("dest"))
            BookListOutcomingRequestRow(title: "title", author: "author", photoId: nil, name: "leon", city: "moscow", date: "2021-05-06T20:15:55.724+00:00", status: .Rejected, destination: Text("dest"))
            BookListOutcomingRequestRow(title: "title", author: "author", photoId: nil, name: "leon", city: "moscow", date: "2021-05-06T20:15:55.724+00:00", status: .Accepted, destination: Text("dest"))
        }
            .previewLayout(.sizeThatFits)
    }
}
