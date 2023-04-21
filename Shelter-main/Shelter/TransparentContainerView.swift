//
//  TransparentContainerView.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/14/23.
//

import UIKit

class TransparentContainerView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if subview.frame.contains(point), !subview.isHidden, subview.alpha > 0, subview.isUserInteractionEnabled {
                return true
            }
        }
        return false
    }
}

