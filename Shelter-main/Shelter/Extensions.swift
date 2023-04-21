//
//  Extensions.swift
//  Shelter
//
//  Created by FSE394 on 4/20/23.
//

import Foundation

import UIKit

extension UIImage {
    func roundedImage(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(origin: .zero, size: size)
        imageLayer.contents = cgImage
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = cornerRadius
        imageLayer.borderWidth = borderWidth
        imageLayer.borderColor = borderColor.cgColor

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        imageLayer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        let prefix = hex.hasPrefix("#") ? 1 : 0
        scanner.currentIndex = String.Index(utf16Offset: prefix, in: hex)

        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        
        let r = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hexValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

