//
//  UISegmentedControl+Extension.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 24.05.2021.
//

import UIKit

extension UISegmentedControl {
    static func setupAppColorTheme() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().backgroundColor = UIColor(white: 1, alpha: 0.25)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(named: "AccentColor")!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
    }
}
