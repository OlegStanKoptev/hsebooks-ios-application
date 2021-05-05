//
//  ReviewsPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 05.05.2021.
//

import SwiftUI

struct ReviewsPage: View {
    var body: some View {
        List {
            ForEach(0..<5) { i in
                Text("Text \(i)")
            }
        }
        .navigationTitle("Reviews")
    }
}

struct ReviewsPage_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsPage()
            .environmentObject(AppState.preview)
    }
}
