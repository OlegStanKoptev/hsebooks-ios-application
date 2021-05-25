//
//  Chat.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 27.03.2021.
//

import SwiftUI

struct Chat: View {
    let book: Book
    let bookBase: BookBase
    let user: User
    let requestId: Int
    
    @ObservedObject var appContext = AppContext.shared
    @StateObject private var viewModel = ViewModel()
    @State private var messageText: String = ""
    @State private var reportFormPresent: Bool = false
    @State private var scrollViewReader: ScrollViewProxy?
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func fetch() {
        viewModel.fetch(requestId: requestId, with: appContext)
    }
    
    func sendMessage() {
        viewModel.send(message: messageText, requestId: requestId, with: appContext) {
            messageText = ""
        }
    }
    
    func isMyMessage(_ message: Message) -> Bool {
        appContext.credentials?.user.id != message.receiverId
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let currentUser = appContext.credentials?.user {
                VStack(spacing: 0) {
                    HStack {
                        Text(bookBase.title)
                        Spacer()
                    }
                    .font(.system(size: 16))
                    
                    HStack {
                        Text(bookBase.author)
                        Spacer()
                    }
                    .font(.system(size: 16))
                    .foregroundColor(Color(.systemGray2))
                    
                    HStack {
                        Spacer()
                        Text(book.creationDate.asDate)
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
                            ForEach(viewModel.messages) { message in
                                HStack {
                                    if isMyMessage(message) {
                                        Spacer(minLength: 32)
                                        ChatBubble(text: message.body, date: message.creationDate.asDate, avatarId: currentUser.avatarId, bubbleType: .outcoming)
                                    } else {
                                        ChatBubble(text: message.body, date: message.creationDate.asDate, avatarId: user.avatarId, bubbleType: .incoming)
                                        Spacer(minLength: 32)
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
                        .onChange(of: viewModel.messages, perform: { value in
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
                .onReceive(timer) { _ in fetch() }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                HStack(spacing: 0) {
                    TextField(viewModel.requestClosed ? "Input is blocked" : "Type your message", text: $messageText) { isEditing in
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
                    .disabled(viewModel.requestClosed)
                    .padding(12)
                    
                    Button(action: {
                        sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(viewModel.requestClosed ? Color.gray : Color.tertiaryColor)
                            )
                    }
                    .disabled(messageText.isEmpty || viewModel.requestClosed)
                }
                .background(
                    Color(.systemGray6)
                        .edgesIgnoringSafeArea(.bottom)
                )
            } else {
                Text("You are not authorized")
            }
        }
        .overlay(StatusOverlay(viewState: $viewModel.viewState, ignoreLoading: true))
        .onAppear { fetch() }
        .sheet(isPresented: $reportFormPresent) {
            ReportForm(requestId: requestId, presented: $reportFormPresent)
        }
        .navigationTitle(user.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Actions") {
                    Button("Report User", action: { reportFormPresent = true })
                }
            }
        }
    }
}

extension Chat {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        @Published var viewState: ViewState = .none
        @Published var requestClosed: Bool = false
        var request: BookExchangeRequest?
        
        func fetch(requestId: Int, with context: AppContext, handler: @escaping () -> Void = {}) {
            guard !context.isPreview, !requestClosed else { return }
            guard let credentials = context.credentials else {
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                let semaphore = DispatchSemaphore(value: 0)
                
                RequestService.shared.makeRequest(to: "\(BookExchangeRequest.request.endpoint)/\(requestId)", using: credentials.token) { [weak self] (result: Result<BookExchangeRequest, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let requestRes):
                        self?.request = requestRes
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                guard let request = self?.request, self?.viewState == .loading else { return }
                guard request.status == .Pending else {
                    if !(self?.requestClosed ?? true) {
                        DispatchQueue.main.async {
                            self?.requestClosed = true
                            self?.viewState = .error(
                                request.status == .Accepted ? "The owner of the book has confirmed the success of this exchange. You cannot send messages anymore" :
                                    "The owner of the book has declined this exchange. You cannot send messages anymore"
                            )
                        }
                    }
                    return
                }
                
                var dialog: Dialog?
                RequestService.shared.makeRequest(to: "\(Dialog.all.endpoint)/\(request.dialogId)", using: credentials.token) { [weak self] (result: Result<Dialog, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let dialogRes):
                        dialog = dialogRes
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                guard let dialog = dialog, self?.viewState == .loading else { return }
                
                let newMessages = dialog.messageIds.filter{ id in !(self?.messages.contains(where: { $0.id == id }) ?? false)}
                let params = [
                    "ids": newMessages.map{String($0)}.joined(separator: ",")
                ]
                RequestService.shared.makeRequest(to: Message.all.endpoint, with: params, using: credentials.token) { [weak self] (result: Result<[Message], RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let messages):
                        self?.messages.append(contentsOf: messages)
                        self?.viewState = .none
                        handler()
                    }
                }
            }
        }
        
        func send(message: String, requestId: Int, with context: AppContext, handler: @escaping () -> Void) {
            guard !context.isPreview else { return }
            guard let credentials = context.credentials else {
                viewState = .error("Not Logged In")
                return
            }
            self.fetch(requestId: requestId, with: context) {
                guard let request = self.request else {
                    self.viewState = .error("Request is not defined")
                    return
                }
                
                self.viewState = .loading
                
                let body = [
                    "body": "\(message)",
                    "dialogId": "\(request.dialogId)"
                ]
                RequestService.shared.makePostRequest(to: Message.all.endpoint, with: credentials.token, body: body) { [weak self] (result: Result<Message, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let messageRes):
                        self?.messages.append(messageRes)
                        self?.viewState = .none
                        handler()
                    }
                }
            }
        }
    }
}

extension Chat {
    struct ReportForm: View {
        let requestId: Int
        @Binding var presented: Bool
        @ObservedObject var appContext = AppContext.shared
        @StateObject var viewModel = ViewModel()
        @State var text: String = ""
        
        private func send() {
            viewModel.sendReport(requestId: requestId, message: text, presented: $presented, context: appContext)
        }
        
        var body: some View {
            NavigationView {
                VStack(spacing: 4) {
                    HStack {
                        Text("Please state your reason:")
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
                    
                    TextEditor(text: $text)
                        .border(Color(.systemGray4), width: 4)
                        .frame(minHeight: 120, maxHeight: 250)
                        .disabled(viewModel.viewState == .loading)
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                .disabled(viewModel.viewState == .loading)
                .overlay(StatusOverlay(viewState: $viewModel.viewState))
                .navigationTitle("Report Form")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: { presented = false })
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Send", action: { send() })
                    }
                }
            }
        }
    }
}

extension Chat.ReportForm {
    class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .none
        
        func sendReport(requestId: Int, message: String, presented: Binding<Bool>, context: AppContext) {
            guard !context.isPreview, viewState != .loading else { return }
            guard let token = context.credentials?.token else {
                viewState = .error("Not Logged In")
                return
            }
            guard !message.isEmpty else {
                viewState = .error("Message cannot be empty!")
                return
            }
            viewState = .loading
            
            let body = [
                "text": message
            ]
            let endpoint = BookExchangeRequest.complaint(for: requestId).endpoint
            RequestService.shared.makePostRequest(to: endpoint, with: token, body: body) { [weak self] (result: Result<Complaint, RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(_):
                    self?.viewState = .none
                    presented.wrappedValue = false
                }
            }
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat(book: .getItems(amount: 1)[0], bookBase: .getItems(amount: 1)[0], user: .getItems(amount: 1)[0], requestId: BookExchangeRequest.getItems(amount: 1)[0].id)
    }
}
