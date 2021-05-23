//
//  ProfilePage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI
import MessageUI

struct ProfilePage: View {
    @ObservedObject var appContext = AppContext.shared
    @Binding var selectedTab: Int
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    func logout() {
        appContext.logOut()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileInfo()) {
                        Label("Profile Information", systemImage: "key")
                    }
                    
                    NavigationLink(destination: Wishlist()) {
                        Label("Wishlist", systemImage: "list.star")
                    }
                    
                    Button(action: { selectedTab = 2 }) {
                        HStack {
                            Label(
                                title: {
                                    Text("My Books")
                                        .foregroundColor(.primary)
                                },
                                icon: { Image(systemName: "book") }
                            )
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 13.5, weight: .semibold, design: .default))
                                .foregroundColor(.init(.systemGray3))
                        }
                    }
                        
                    Button(action: { selectedTab = 3 }) {
                        HStack {
                            Label(
                                title: {
                                    Text("My Requests")
                                        .foregroundColor(.primary)
                                },
                                icon: { Image(systemName: "bubble.left.and.bubble.right") }
                            )
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 13.5, weight: .semibold, design: .default))
                                .foregroundColor(.init(.systemGray3))
                        }
                    }
                }
                
                Section {
                    VStack {
                        Button(action: {
                            if MFMailComposeViewController.canSendMail() {
                                UINavigationBar.removeAppColorTheme()
                                self.isShowingMailView.toggle()
                            } else {
                                print("cannot show email")
                            }
                        }) {
                            HStack {
                            Label(
                                title: {
                                    Text("Write our support team!")
                                        .foregroundColor(.primary)
                                    },
                                icon: { Image(systemName: "square.and.pencil") }
                            )

                            Spacer()

                            Image(systemName: "chevron.forward")
                                .font(.system(size: 13.5, weight: .semibold, design: .default))
                                .foregroundColor(.init(.systemGray3))
                            }
                        }
                    }
                }

//                    NavigationLink(destination: NotificationsPage()) {
//                        Label("Notifications", systemImage: "bell")
//                    }
//                    .disabled(true)
//
//                    NavigationLink(destination: ReviewsPage()) {
//                        Label("My Reviews (Not Ready)", systemImage: "ellipses.bubble")
//                    }
//                    .disabled(true)

//                Section(header: Text("Settings")) {
//                    NavigationLink(destination: Text("Destination")) {
//                        HStack {
//                            Text("Language (Not Ready)")
//                            Spacer()
//                            Text("RUS")
//                                .foregroundColor(.secondary)
//                        }
//                    }
//
//                    Toggle("Only Wi-Fi (Not Ready)", isOn: .constant(false))
//
//                    NavigationLink(destination: Text("Destination")) {
//                        Text("Help (Not Ready)")
//                    }
//                }
//                .disabled(true)

                Section {
                    Button(action: { logout() }) {
                        Label("Log Out", systemImage: "escape")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView, result: self.$result) {
                    UINavigationBar.setupAppColorTheme()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage(selectedTab: .constant(0))
            .environmentObject(AppContext.preview)
    }
}
