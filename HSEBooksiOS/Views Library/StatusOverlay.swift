//
//  StatusOverlay.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import SwiftUI

struct SpinnerView: View {
    var body: some View {
        ProgressView()
            .padding()
            .background(Color(.systemGray5).cornerRadius(12))
            .transition(.opacity)
            .animation(.easeInOut)
    }
}

struct TextOverlay: View {
    let text: String
    var body: some View {
        VStack {
            Image(systemName: "xmark.circle")
                .font(.system(size: 24))
            Text(text)
        }
        .padding()
        .background(Color(.systemGray5).cornerRadius(12))
        .transition(.opacity)
        .animation(.easeInOut)
    }
}

struct StatusOverlay: View {
    @Binding var viewState: ViewState
    var ignoreError: Bool = false
    var ignoreLoading: Bool = false
    var body: some View {
        Group {
            switch viewState {
            case .none:
                EmptyView()
            case .loading:
                if ignoreLoading {
                    EmptyView()
                } else {
                    SpinnerView()
                }
            case .error(let message):
                if ignoreError {
                    EmptyView()
                } else {
                    TextOverlay(text: message)
                        .onTapGesture {
                            viewState = .none
                        }
                }
            }
        }
    }
}

struct StatusOverlay_Previews: PreviewProvider {
    static var previews: some View {
        StatusOverlay(viewState: .constant(.none))
    }
}
