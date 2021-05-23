//
//  MailView.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 22.05.2021.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    var onDismiss: () -> Void = {}
    private let email: String = "hsebooks@hse.ru"

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        var onDismiss: () -> Void

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>,
             onDismiss: @escaping () -> Void) {
            _isShowing = isShowing
            _result = result
            self.onDismiss = onDismiss
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                onDismiss()
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result,
                           onDismiss: onDismiss)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([ email ])
        vc.setSubject("Error report")
        vc.setMessageBody("\nHello! I have that terrible error...", isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
