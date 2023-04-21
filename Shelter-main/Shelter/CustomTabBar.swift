//
//  CustomTabBar.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/13/23.
//

import UIKit

class CustomTabBar: UITabBar {

    @IBInspectable var tabBarHeight: CGFloat = 60.0
    @IBInspectable var horizontalInset: CGFloat = 16.0
    @IBInspectable var bottomInset: CGFloat = 35.0

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.height = tabBarHeight
        return newSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newTabBarFrame = CGRect(
            x: horizontalInset,
            y: (superview?.bounds.height ?? 0) - tabBarHeight - bottomInset,
            width: (superview?.bounds.width ?? 0) - 2 * horizontalInset,
            height: tabBarHeight
        )
        
        frame = newTabBarFrame
        layer.cornerRadius = tabBarHeight / 2
        clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemPositioning = .fill
        itemWidth = (frame.width - 2 * horizontalInset) / CGFloat(items?.count ?? 1)
        itemSpacing = 0
        
        for item in items ?? [] {
            item.image = item.image?.withRenderingMode(.alwaysTemplate)
            item.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
            item.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
        }
    }
}





