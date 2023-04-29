//
//  HomeViewController.swift
//  Shelter
//
//  Created by FSE394 on 4/28/23.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var homeContainer: UIView!
    @IBOutlet var findLabel: UILabel!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchViewContainer: UIView!
    //@IBOutlet var changingWordLabel: UILabel!
    
    var index: Int = 0
    var changeTextTimer: Timer?
    var currentWordIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelText(text: "Find community near you", coloredWord: "community", color: UIColor(red: 0.62, green: 0.91, blue: 0.44, alpha: 1.0))
        
        homeContainer.layer.cornerRadius = 20
        homeContainer.layer.masksToBounds = true
        
        let part1 = "Welcome, "
        let part2 = "User"
        let part1Attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 26) // Change the font size if needed
        ]
        let part2Attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 26, weight: .heavy) // Use a heavier font weight
        ]
        let attributedTitle = NSMutableAttributedString(string: part1, attributes: part1Attributes)
        attributedTitle.append(NSAttributedString(string: part2, attributes: part2Attributes))
        greetingLabel.attributedText = attributedTitle // Set the attributed text for the UILabel
        
        searchField.delegate = self
        searchField.backgroundColor = .clear
        let cornerRadius: CGFloat = 10.0 // Change this value to adjust the corner radius
        searchViewContainer.addShadow(cornerRadius: cornerRadius)
        
        let fontSize: CGFloat = 16 // Replace '20' with your desired font size
        func setThickerPlaceholder(for textField: UITextField, placeholderText: String) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Inter-SemiBold", size: fontSize)!,
                .foregroundColor: UIColor.gray
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }

        setThickerPlaceholder(for: searchField, placeholderText: "Search")
        searchField.layer.borderColor = UIColor.black.cgColor
        searchField.layer.borderWidth = 1.0
        
        // Set up the search icon
        let searchIcon = UIImage(systemName: "magnifyingglass") // Replace with your own image if not using SF Symbols
        let searchIconImageView = UIImageView(image: searchIcon)
        searchIconImageView.tintColor = .gray
        searchIconImageView.contentMode = .scaleAspectFit
        searchIconImageView.frame = CGRect(x: -5, y: -1, width: 24, height: 24)
        
        // Add some padding to the left of the icon
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(searchIconImageView)
        
        // Set the leftView property of the text field
        searchField.rightView = paddingView
        searchField.rightViewMode = .always
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "showSearchPage", sender: self)
        return false
    }
    
    func setLabelText(text: String, coloredWord: String, color: UIColor) {
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: coloredWord)
        attributedText.addAttribute(.foregroundColor, value: color, range: range)
        findLabel.attributedText = attributedText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeLabelText()
        changeTextTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeLabelText), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeTextTimer?.invalidate()
    }
    
    @objc func changeLabelText() {
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let words = ["communities", "mentors", "clinics"]
        let colors: [UIColor] = [
            UIColor(hex: "9FE870"),
            UIColor(hex: "9FE870"),
            UIColor(hex: "9FE870")
        ]
        
        index = (index + 1) % words.count
        let word = words[index]
        let color = colors[index]
        
        let attributedString = NSMutableAttributedString(string: "Find \(word) near you")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 5, length: word.count))
        
        findLabel.layer.add(transition, forKey: kCATransition)
        findLabel.attributedText = attributedString
    }
}
