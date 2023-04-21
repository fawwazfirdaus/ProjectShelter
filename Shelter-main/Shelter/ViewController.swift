//
//  ViewController.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/2/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var pNumberTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var pNumberTextFieldContainer: UIView!
    @IBOutlet var passwordTextFieldContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the UITextField delegate
            pNumberTextField.delegate = self
            passwordTextField.delegate = self
            
            pNumberTextField.backgroundColor = .clear
            passwordTextField.backgroundColor = .clear

            let cornerRadius: CGFloat = 10.0 // Change this value to adjust the corner radius
            pNumberTextFieldContainer.addShadow(cornerRadius: cornerRadius)
            passwordTextFieldContainer.addShadow(cornerRadius: cornerRadius)
        
        func setThickerPlaceholder(for textField: UITextField, placeholderText: String) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: textField.font?.pointSize ?? 17, weight: .bold),
                .foregroundColor: UIColor.gray
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }

        setThickerPlaceholder(for: pNumberTextField, placeholderText: "Phone Number")
        setThickerPlaceholder(for: passwordTextField, placeholderText: "Password")
        
        pNumberTextField.layer.borderColor = UIColor.black.cgColor
        pNumberTextField.layer.borderWidth = 1.0

        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 1.0


        
        // Dismiss the keyboard when tapping outside the UITextField
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        tapGesture.delegate = self // Set the UITapGestureRecognizer delegate
        view.addGestureRecognizer(tapGesture)
        
        // Set the text alignment of the UIButton to left
        signUpButton.contentHorizontalAlignment = .left

        // Set the title of the UIButton with different font styles
        let part1 = "Don't have an account? "
        let part2 = "Sign Up here"
        let part1Attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17) // Change the font size if needed
        ]
        let part2Attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .heavy) // Use a heavier font weight
        ]
        let attributedTitle = NSMutableAttributedString(string: part1, attributes: part1Attributes)
        attributedTitle.append(NSAttributedString(string: part2, attributes: part2Attributes))
        signUpButton.setAttributedTitle(attributedTitle, for: .normal)
        
        // Creating radius corner for the login button
        logInButton.layer.cornerRadius = 25
        logInButton.layer.masksToBounds = true
        
        let logInButtonText = "Log In"
        let attributedTitleTwo = NSMutableAttributedString(string: logInButtonText, attributes: part2Attributes)
        logInButton.setAttributedTitle(attributedTitleTwo, for: .normal)
    }


    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        return true
    }


}

