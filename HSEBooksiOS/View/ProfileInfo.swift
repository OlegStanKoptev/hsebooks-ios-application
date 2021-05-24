//
//  ProfileInfo.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 05.05.2021.
//

import SwiftUI

struct ProfileInfo: View {
    @ObservedObject var appContext = AppContext.shared
    @StateObject var viewModel = ViewModel()
    @State private var imageSelectorPresented: Bool = false
    @State private var editingImage: UIImage?
    @State private var editingName: String = ""
    @State private var chosenTown: Town?
    
    private func showImageSelector() {
        imageSelectorPresented = true
    }
    
    private func fetch() {
        viewModel.fetch(context: appContext)
    }
    
    private func edit() {
        guard let user = appContext.credentials?.user else { return }
        editingName = user.name
        chosenTown = appContext.towns.first(where: {$0.id == user.townId})
        viewModel.isEditing = true
    }
    
    private func cancel() {
        viewModel.isEditing = false
    }
    
    private func done() {
        viewModel.updateUser(name: editingName, image: editingImage, town: chosenTown, context: appContext)
    }
    
    var normalView: some View {
        Group {
            if let user = appContext.credentials?.user {
                HStack(spacing: 16) {
                    Spacer(minLength: 0)
                    
                    UserAvatarView(id: user.avatarId)
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                            .font(.headline)
                        
                        Text(user.username)
                            .font(.subheadline)
                        
                        Group {
                            if let town = appContext.towns.first(where: {$0.id == user.townId}) {
                                Text(town.name)
                            } else {
                                Text("No default town selected")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding(.trailing)
                    
                    Spacer(minLength: 0)
                    Spacer(minLength: 0)
                    Spacer(minLength: 0)
                }
                .padding(.vertical, 4)
                
                Section {
                    Row(key: "Requests to add bookBase", value: "\(user.bookBaseAddRequestIds.count)")
                    Row(key: "Wishlist Items", value: "\(user.wishListIds.count)")
                    Row(key: "Books owned", value: "\(user.exchangeListIds.count)")
                    Row(key: "Complaints sent", value: "\(user.complaintsIds.count)")
                    Row(key: "Outcoming Exchange Requests", value: "\(user.incomingBookExchangeRequestIds.count)")
                    Row(key: "Incoming Exchange Requests", value: "\(user.outcomingBookExchangeRequestIds.count)")
                }
            } else {
                Text("No user data available")
            }
        }
    }
    
    var editingView: some View {
        Group {
            if let user = appContext.credentials?.user {
                HStack {
                    Spacer()
                    Button(action: { showImageSelector() }) {
                        Group {
                            if let editingImage = editingImage {
                                UserAvatarView(image: Image(uiImage: editingImage))
                            } else {
                                UserAvatarView(id: user.avatarId)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.5)
                        .overlay(
                            ZStack {
                                Color.black.opacity(0.1)
                                Text("Replace")
                                    .shadow(radius: 3)
                            }
                            .clipShape(Circle())
                        )
                    }
                    Spacer()
                }
                
                Section {
                    HStack {
                        Text("Name: ")
                        Divider()
                        TextField("Name", text: $editingName)
                    }
                    
                    HStack {
                        Text("Town:  ")
                        Divider()
//                        TextField("Name", text: $editingName)
                        Menu(chosenTown?.name ?? "None") {
                            ForEach(appContext.towns) { town in
                                Button(town.name, action: { chosenTown = town })
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            } else {
                Text("No user data available")
            }
        }
    }
    
    var body: some View {
        List {
            if appContext.credentials != nil {
                if !viewModel.isEditing {
                    normalView
                } else {
                    editingView
                }
            } else {
                Text("No user information available")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Group {
                    if viewModel.isEditing {
                        Button("Done", action: done)
                    } else {
                        Button("Edit", action: edit)
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Group {
                    if viewModel.isEditing {
                        Button("Cancel", action: cancel)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .disabled(viewModel.viewState == .loading)
        .listStyle(GroupedListStyle())
        .overlay(StatusOverlay(viewState: $viewModel.viewState))
        .onAppear { fetch() }
        .sheet(isPresented: $imageSelectorPresented) {
            PhotoPicker(isPresented: $imageSelectorPresented) { image in
                editingImage = image
            }
        }
        .navigationTitle("Profile Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ProfileInfo {
    struct Row: View {
        let key: String
        let value: String
        var body: some View {
            HStack {
                Text(key)
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension ProfileInfo {
    class ViewModel: ObservableObject {
//        @Published var user: User?
        @Published var viewState: ViewState = .none
        @Published var isEditing: Bool = false
        
        func fetch(context: AppContext) {
            guard !context.isPreview else { return }
            DispatchQueue.main.async { [weak self] in
                self?.viewState = .loading
            }
            context.updateUserInfo { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(_):
                    self?.isEditing = false
                    self?.viewState = .none
                }
            }
        }
        
        func updateUser(name: String, image: UIImage?, town: Town?, context: AppContext) {
            guard !context.isPreview else { return }
            guard let credentials = context.credentials else {
                viewState = .error("Not Logged In")
                return
            }
            guard !name.isEmpty else {
                viewState = .error("Name cannot be empty!")
                return
            }
            viewState = .loading
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                let semaphore = DispatchSemaphore(value: 0)
                
                if name != credentials.user.name ||
                    town?.id != credentials.user.townId {
                    var userRes: User?
                    var userBody = [
                        "name": "\(name)"
                    ]
                    if let town = town {
                        userBody["townId"] = String(town.id)
                    }
                    
                    RequestService.shared.makePutRequest(to: "\(User.user.endpoint)/\(credentials.user.id)", with: credentials.token, body: userBody) { [weak self] (result: Result<User, RequestError>) in
                        switch result {
                        case .failure(let error):
                            self?.viewState = .error(error.description)
                        case .success(let user):
                            userRes = user
                        }
                        semaphore.signal()
                    }
                    semaphore.wait()
                    guard userRes != nil else { return }
                    DispatchQueue.main.async {
                        context.credentials?.user = User.default
                    }
                }
                
                guard let image = image,
                    let imageData = image.jpegData(compressionQuality: 0.3) else {
                    self?.fetch(context: context)
                    return
                }
                let imageString = imageData.base64EncodedString()
                var imageRes: Avatar?
                let imageBody = [
                    "image": "\(imageString)"
                ]
                
                RequestService.shared.makePostRequest(to: Avatar.avatar.endpoint, with: credentials.token, body: imageBody) { [weak self] (result: Result<Avatar, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let photo):
                        imageRes = photo
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                guard imageRes != nil else { return }
                
                context.updateUserInfo { [weak self] result in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(_):
                        self?.fetch(context: context)
                    }
                }
            }
        }
    }
}

struct ProfileInfo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileInfo(appContext: .preview)
        }
    }
}
