//
//  HealthViewController.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/14/23.
//

import UIKit

class HealthViewController: UIViewController {

    @IBOutlet var healtContainer: UIView!
    @IBOutlet var letsFindOutButton: UIButton!
    @IBOutlet var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        healtContainer.layer.cornerRadius = 30 // Change this value to adjust the corner radius
        healtContainer.layer.masksToBounds = true
        
        letsFindOutButton.layer.cornerRadius = 25
        letsFindOutButton.layer.masksToBounds = true
        
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold) // Use a heavier font weight
        ]
        
        let letsFindOutButtonText = "Let's find out!"
        let attributeTitle = NSMutableAttributedString(string: letsFindOutButtonText, attributes: attributes)
        letsFindOutButton.setAttributedTitle(attributeTitle, for: .normal)
                
        // Set the title of the UILabel with different font styles
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

    }
}

