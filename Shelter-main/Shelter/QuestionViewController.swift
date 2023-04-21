//
//  QuestionViewController.swift
//  Shelter
//
//  Created by FSE394 on 4/20/23.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var choiceButtons: [UIButton]!
    
    var question: Question!
    var submitAnswer: ((Int) -> Void)?
    var selectedChoiceIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let question = question else {
            fatalError("Question property is not set for QuestionViewController")
        }
        
        questionLabel.text = question.text
        for (index, button) in choiceButtons.enumerated() {
            button.setTitle(question.choices[index], for: .normal)
        }
        
        configureChoiceButtons()
        navigationController?.navigationBar.tintColor = .black
    }

    @IBAction func choiceButtonTapped(_ sender: UIButton) {
        guard let index = choiceButtons.firstIndex(of: sender) else { return }
        
        let points = index // Use the index as the point value (0 to 3)
        submitAnswer?(points)
    }
    
    func configureChoiceButtons() {
        let fontSize: CGFloat = 18 // Replace '20' with your desired font size
        let font = UIFont(name: "Inter-Bold", size: fontSize)
        
        for button in choiceButtons {
            button.layer.cornerRadius = 25
            button.clipsToBounds = true
            
            let title = button.title(for: .normal) ?? ""
            let attributedTitle = NSAttributedString(string: title, attributes: [.font: font!])
            button.setAttributedTitle(attributedTitle, for: .normal)
        }
    }

}
