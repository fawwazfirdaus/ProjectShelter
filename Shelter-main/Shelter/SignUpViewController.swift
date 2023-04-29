//
//  SignUpViewController.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/13/23.
//

import CoreData
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {


    @IBOutlet var pNumberTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var cPasswordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var haveAccountButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var pNumberTextFieldContainer: UIView!
    @IBOutlet var passwordTextFieldContainer: UIView!
    @IBOutlet var cPasswordTextFieldContainer: UIView!
    @IBOutlet var usernameTextFieldContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the UITextField delegate
        usernameTextField.delegate = self
        pNumberTextField.delegate = self
        passwordTextField.delegate = self
        cPasswordTextField.delegate = self
        
        usernameTextField.backgroundColor = .clear
        pNumberTextField.backgroundColor = .clear
        passwordTextField.backgroundColor = .clear
        cPasswordTextField.backgroundColor = .clear
        
        let cornerRadius: CGFloat = 10.0 // Change this value to adjust the corner radius
        
        usernameTextFieldContainer.addShadow(cornerRadius: cornerRadius)
        pNumberTextFieldContainer.addShadow(cornerRadius: cornerRadius)
        passwordTextFieldContainer.addShadow(cornerRadius: cornerRadius)
        cPasswordTextFieldContainer.addShadow(cornerRadius: cornerRadius)
        
        passwordTextField.isSecureTextEntry = true
        cPasswordTextField.isSecureTextEntry = true
        
        func setThickerPlaceholder(for textField: UITextField, placeholderText: String) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: textField.font?.pointSize ?? 17, weight: .bold),
                .foregroundColor: UIColor.gray
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
        
        setThickerPlaceholder(for: usernameTextField, placeholderText: "Username")
        setThickerPlaceholder(for: pNumberTextField, placeholderText: "Phone Number")
        setThickerPlaceholder(for: passwordTextField, placeholderText: "Password")
        setThickerPlaceholder(for: cPasswordTextField, placeholderText: "Confirm Password")
        
        usernameTextField.layer.borderColor = UIColor.black.cgColor
        usernameTextField.layer.borderWidth = 1.0
        
        pNumberTextField.layer.borderColor = UIColor.black.cgColor
        pNumberTextField.layer.borderWidth = 1.0

        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 1.0
        
        cPasswordTextField.layer.borderColor = UIColor.black.cgColor
        cPasswordTextField.layer.borderWidth = 1.0
        
        // Dismiss the keyboard when tapping outside the UITextField
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        tapGesture.delegate = self // Set the UITapGestureRecognizer delegate
        view.addGestureRecognizer(tapGesture)
        
        // Set the text alignment of the UIButton to left
        haveAccountButton.contentHorizontalAlignment = .left
        
        // Set the title of the UIButton with different font styles
        let part1 = "Already have an account? "
        let part2 = "Log In here"
        let part1Attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17) // Change the font size if needed
        ]
        let part2Attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .heavy) // Use a heavier font weight
        ]
        let attributedTitle = NSMutableAttributedString(string: part1, attributes: part1Attributes)
        attributedTitle.append(NSAttributedString(string: part2, attributes: part2Attributes))
        
        haveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
        
        signUpButton.layer.cornerRadius = 25
        signUpButton.layer.masksToBounds = true
        
        let signUpButtonText = "Sign Up"
        let attributedTitleTwo = NSMutableAttributedString(string: signUpButtonText, attributes: part2Attributes)
        signUpButton.setAttributedTitle(attributedTitleTwo, for: .normal)
        
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
    
    @IBAction func signUpButton(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let phoneNumberString = pNumberTextField.text, !phoneNumberString.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = cPasswordTextField.text, !confirmPassword.isEmpty else {
            // Show error: some fields are empty
            return
        }
        
        guard password == confirmPassword else {
            // Show error: passwords do not match
            return
        }
        
        if isValueUnique(entity: "User", attribute: "username", value: username) &&
                isValueUnique(entity: "User", attribute: "phoneNumber", value: phoneNumberString) &&
                isValueUnique(entity: "User", attribute: "password", value: password) {
                saveUser(username: username, phoneNumber: phoneNumberString, password: password)
                // Navigate to CustomTabBarController
                if let tabBarViewController = instantiateCustomTabBarController() {
                    tabBarViewController.modalPresentationStyle = .fullScreen
                    self.present(tabBarViewController, animated: true, completion: nil)
                }
            } else {
                // Show error: one of the values is not unique
            }
    }
    
    func saveUser(username: String, phoneNumber: String, password: String) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
            let newUser = NSManagedObject(entity: entity, insertInto: context)

            newUser.setValue(username, forKey: "username")
            newUser.setValue(phoneNumber, forKey: "phoneNumber")
            newUser.setValue(password, forKey: "password")

            do {
                try context.save()
                print("User saved successfully")
                // Perform any necessary action after saving, e.g., navigate to another view controller

            } catch let error as NSError {
                print("Could not save user. \(error), \(error.userInfo)")
            }
        }
    
    func isValueUnique(entity: String, attribute: String, value: Any) -> Bool {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            
            if let stringValue = value as? String {
                fetchRequest.predicate = NSPredicate(format: "%K == %@", attribute, stringValue)
            } else if let intValue = value as? Int {
                fetchRequest.predicate = NSPredicate(format: "%K == %d", attribute, intValue)
            }

            do {
                let result = try context.fetch(fetchRequest)
                return result.isEmpty
            } catch {
                print("Error checking uniqueness: \(error)")
                return false
            }
        }
    
    func instantiateCustomTabBarController() -> CustomTabBarController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController
        return viewController
    }
}
