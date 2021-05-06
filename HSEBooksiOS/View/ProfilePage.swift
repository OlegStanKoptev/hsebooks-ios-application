//
//  ProfilePage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI


struct ProfilePage: View {
    func logout() {
//        appState.logOut()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileInfo()) {
                        Label("Profile Information", systemImage: "key")
                    }
                    
                    NavigationLink(destination: Text("Wishlist")) {
                        Label("Wishlist", systemImage: "list.star")
                    }

                    NavigationLink(destination: NotificationsPage()) {
                        Label("Notifications", systemImage: "bell")
                    }

                    NavigationLink(destination: ReviewsPage()) {
                        Label("My Reviews", systemImage: "ellipses.bubble")
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
    }
}
