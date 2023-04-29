//
//  CustomTabBarController.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/13/23.
//

import UIKit


class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var highlightViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupHighlightViews()
        
        if let items = self.tabBar.items {
            for item in items {
                if let image = item.image {
                    item.image = image.withRenderingMode(.alwaysTemplate)
                }
            }
        }
        self.tabBar.unselectedItemTintColor = UIColor(red: 0.62, green: 0.91, blue: 0.43, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateHighlightViews()
        }
    }
    
    private func setupHighlightViews() {
        guard let tabBarItems = tabBar.items else { return }
        
        for (index, item) in tabBarItems.enumerated() {
            let highlightView = UIView()
            highlightView.backgroundColor = .clear
            
            if let imageView = item.value(forKey: "view") as? UIImageView, let image = imageView.image {
                // Set the corner radius to half of the tab bar item image size
                highlightView.layer.cornerRadius = image.size.width / 2
            } else {
                // Fallback to a default corner radius if the image size cannot be determined
                highlightView.layer.cornerRadius = tabBar.bounds.height / 6
            }
            
            highlightView.tag = index
            highlightView.isUserInteractionEnabled = false
            tabBar.insertSubview(highlightView, at: 0) // Insert highlight view behind tab bar items
            highlightViews.append(highlightView)
        }
        
        updateHighlightViews()
    }
    
//    private func updateHighlightViews() {
//        let itemWidth = tabBar.bounds.width / CGFloat(highlightViews.count)
//
//        for (index, highlightView) in highlightViews.enumerated() {
//            let isSelected = index == selectedIndex
//            let x = CGFloat(index) * itemWidth
//            let centerY = tabBar.bounds.height / 2
//            highlightView.frame = CGRect(x: x, y: 0, width: itemWidth, height: tabBar.bounds.height)
//            highlightView.center = CGPoint(x: x + itemWidth / 2, y: centerY)
//            highlightView.backgroundColor = isSelected ? UIColor(red: 0.62, green: 0.91, blue: 0.43, alpha: 1.0) : .clear
//
//        }
//    }
    
    private func updateHighlightViews() {
        let itemWidth = tabBar.bounds.width / CGFloat(highlightViews.count)
        
        for (index, highlightView) in highlightViews.enumerated() {
            let isSelected = index == selectedIndex
            let x = CGFloat(index) * itemWidth
            let centerY = tabBar.bounds.height / 2
            
            // Change the highlight view's frame to be a square
            let sideLength = tabBar.bounds.height * 0.7
            highlightView.frame = CGRect(x: x, y: 0, width: sideLength, height: sideLength)
            highlightView.center = CGPoint(x: x + itemWidth / 2, y: centerY)
            
            // Update the corner radius to create a circular highlight
            highlightView.layer.cornerRadius = sideLength / 2
            highlightView.backgroundColor = isSelected ? UIColor(red: 0.62, green: 0.91, blue: 0.43, alpha: 1.0) : .clear
        }
    }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateHighlightViews()
    }
}






