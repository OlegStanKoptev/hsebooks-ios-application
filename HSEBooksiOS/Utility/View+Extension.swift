//
//  View+Extension.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 24.04.2021.
//
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
