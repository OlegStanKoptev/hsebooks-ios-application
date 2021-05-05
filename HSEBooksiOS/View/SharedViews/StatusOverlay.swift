//
//  StatusOverlay.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import SwiftUI

struct StatusOverlay: View {
    @Binding var viewState: ViewState
    var body: some View {
        Group {
            switch viewState {
            case .none, .result:
                EmptyView()
            case .loading:
                SpinnerView()
            case .error(let message):
                TextOverlay(text: message)
            }
        }
    }
}

struct StatusOverlay_Previews: PreviewProvider {
    static var previews: some View {
        StatusOverlay(viewState: .constant(.none))
    }
}
