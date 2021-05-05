//
//  ProfilePage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI


struct ProfilePage: View {
    @EnvironmentObject var appState: AppState
    
    func logout() {
        appState.logOut()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileInfo()) {
                        Label("Profile Information", systemImage: "key")
                    }
                    
                    Button(action: { appState.chosenTab = .favorites }) {
                        Label("Favorites", systemImage: "heart")
                    }

                    NavigationLink(destination: NotificationsPage()) {
                        Label("Notifications", systemImage: "bell")
                    }

                    NavigationLink(destination: ReviewsPage()) {
                        Label("My Reviews", systemImage: "ellipses.bubble")
                    }
                }
                
                Section {
                    NavigationLink(destination: MyBooksPage()) {
                        Label("My Books", systemImage: "book")
                    }
                }

                Section {
                    NavigationLink(destination: MyRequestsPage()) {
                        Label("My Requests", systemImage: "bubble.left.and.bubble.right")
                    }
                }

                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Destination")) {
                        HStack {
                            Text("Language")
                            Spacer()
                            Text("RUS")
                                .foregroundColor(.secondary)
                        }
                    }

                    Toggle("Only Wi-Fi", isOn: .constant(false))

                    NavigationLink(destination: Text("Destination")) {
                        Text("Help")
                    }
                }

                Section {
                    Button(action: { logout() }) {
                        Label("Log Out", systemImage: "escape")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
            .environmentObject(AppState.preview)
    }
}
