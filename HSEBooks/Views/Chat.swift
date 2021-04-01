//
//  Chat.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 27.03.2021.
//

import SwiftUI

struct Chat: View {
    struct Message: Equatable, Identifiable {
        enum Sender {
            case none, currentUser, otherUser
        }
        
        let id = UUID()
        var text = "This is a message"
        var date: Date = Date.distantPast
        var sender: Sender = .none
    }
    
    let title: String
    @State private var messages: [Message] = [
        .init(text: "Initial message", sender: .none),
    ]
    @State private var messageText: String = ""
    @State private var scrollViewReader: ScrollViewProxy?
    
    private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    private let dateFormatter: DateFormatter
    
    init(title: String = "Default Title") {
        self.title = title
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }
    
    func sendMessage() {
        let text = messageText
        if !text.isEmpty {
            messages.append(Message(text: text, date: Date(), sender: .currentUser))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                messages.append(Message(text: "You said '\(text)'", date: Date(), sender: .otherUser))
            }
            messageText = ""
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: title)
                .navigationBarBackgroundStyle()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Book name")
                    Spacer()
                }
                .font(.system(size: 16))
                
                HStack {
                    Text("Author name")
                    Spacer()
                }
                .font(.system(size: 16))
                .foregroundColor(Color(.systemGray2))
                
                HStack {
                    Spacer()
                    Text(dateFormatter.string(from: Date.distantPast))
                }
                .font(.system(size: 15))
                .foregroundColor(Color(.systemGray2))
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 1, x: 0.0, y: 1.0)
            )
            .padding([.top, .horizontal], 8)
            .padding(.bottom, 1)
            
            ScrollView(.vertical) {
                ScrollViewReader { svr in
                    VStack(spacing: 12) {
                        ForEach(messages) { message in
                            HStack {
                                if message.sender == .currentUser {
                                    Spacer(minLength: 32)
                                    ChatBubble(text: message.text, date: dateFormatter.string(from: message.date), bubbleType: .outcoming)
                                } else if message.sender == .otherUser {
                                    ChatBubble(text: message.text, date: dateFormatter.string(from: message.date), bubbleType: .incoming)
                                    Spacer(minLength: 32)
                                } else {
                                    ChatBubble(text: message.text)
                                }
                            }
                            .id(message.id)
                        }
                        Color.clear
                            .frame(height: 0)
                            .id(0)
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 8)
                    .onAppear {
                        scrollViewReader = svr
                        svr.scrollTo(0)
                    }
                    .onChange(of: messages, perform: { value in
                        withAnimation {
                            svr.scrollTo(0)
                        }
                    })
                }
            }
            .background(
                GeometryReader { geo in
                    Image("ScreenBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.15)
                }
            )
//            .onReceive(timer) { _ in
//                messages.append(Message(text: "System message sent every once in a while", sender: .otherUser))
//            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            HStack(spacing: 0) {
                TextField("Type your message", text: $messageText) { isEditing in
                    if isEditing {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                scrollViewReader?.scrollTo(0)
                            }
                        }
                    }
                } onCommit: {
                    sendMessage()
                }
                .padding(12)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(13)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("SecondColor"))
                        )
                }
                .disabled(messageText.isEmpty)
            }
            .background(
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .navigationBarHidden(true)
    }
}

struct NewChat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
