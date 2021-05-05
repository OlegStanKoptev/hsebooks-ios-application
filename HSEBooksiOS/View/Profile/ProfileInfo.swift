//
//  ProfileInfo.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 05.05.2021.
//

import SwiftUI

struct ProfileInfo: View {
    @EnvironmentObject var appState: AppState
    var fields: [(label: String, value: Any)] {
        Mirror(reflecting: appState.authData.currentUser ?? Void.self).children.map { (label: $0.label!, value: $0.value) }
    }
    
    var body: some View {
        List(fields, id: \.label) { field in
            Text(field.label)
            Spacer()
            Text((field.value as AnyObject).description)
                .foregroundColor(.secondary)
        }
        .listStyle(GroupedListStyle())
        .overlay(
            StatusOverlay(viewState: $appState.authData.authState)
        )
        .onAppear {
            appState.authData.updateProfileInfo()
        }
        .navigationTitle("Profile Information")
    }
}

struct ProfileInfo_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfo()
            .environmentObject(AppState.preview)
    }
}
