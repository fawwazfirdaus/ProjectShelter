//
//  QuizResultViewController.swift
//  Shelter
//
//  Created by FSE394 on 4/20/23.
//

import Foundation
import UIKit

class QuizResultViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var getHelpButton: UIButton!
    @IBOutlet var resourceButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    
    var quizResult: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Your score is \(quizResult ?? Int()) out of 30"
        displayQuizResult()
        
        navigationItem.hidesBackButton = true

        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        configureResultButtons()
    }
    
    @objc func backButtonTapped(_ sender: Any) {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let quizVC = viewController as? QuizViewController {
                    navigationController.popToViewController(quizVC, animated: true)
                    break
                }
            }
        }
    }

    

    func displayQuizResult() {
        let result: (String)
        if quizResult <= 10 {
            result = ("Based upon your responses to the test, you are unlikely to have ADHD")
        } else if quizResult <= 20 {
            result = ("Based upon your responses to the test, you may or may not have ADHD")
        } else {
            result = ("Based upon your responses to the test, you are likely to have ADHD")
        }
        descriptionLabel.text = result
    }
    
    func navigateBackToQuizViewController() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let quizViewController = viewController as? QuizViewController {
                    print("Quiz view is found")
                    navigationController.popToViewController(quizViewController, animated: true)
                    break
                }
            }
        }
    }
    
    func configureResultButtons() {
        let fontSize: CGFloat = 18
        let font = UIFont(name: "Inter-Bold", size: fontSize)

        let buttons = [getHelpButton, resourceButton]
        for button in buttons {
            button!.layer.cornerRadius = 25
            button!.clipsToBounds = true
            button!.titleLabel!.font = font
        }
    }
}

//            let title = button!.title(for: .normal) ?? ""
//            let attributedTitle = NSAttributedString(string: title, attributes: [.font: font!])
//            button!.setAttributedTitle(attributedTitle, for: .normal)
