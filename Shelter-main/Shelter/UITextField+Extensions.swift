//
//  UITextField+Extensions.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/13/23.
//
import UIKit
extension UIView {
    func addShadow(cornerRadius: CGFloat = 0) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4
    }
}


