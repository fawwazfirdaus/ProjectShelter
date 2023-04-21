//
//  StrokeButton.swift
//  Shelter
//
//  Created by FSE394 on 4/18/23.
//

import Foundation
import UIKit

class InsideStrokeButton: UIButton {
    
    @IBInspectable var strokeWidth: CGFloat = 2
    @IBInspectable var strokeColor: UIColor = .black

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius)
        
        path.lineWidth = strokeWidth
        strokeColor.setStroke()
        path.stroke()
    }
}

