//
//  ViewController.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/2/23.
//

import CoreData
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
        
        passwordTextField.isSecureTextEntry = true


        
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
        

        fetchUsers()
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
    
    func fetchUsers() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

            do {
                let users = try context.fetch(fetchRequest)
                
                // Print the fetched users in Xcode output
                for (index, user) in users.enumerated() {
                    let username = user.value(forKey: "username") as? String ?? ""
                    let phoneNumber = user.value(forKey: "phoneNumber") as? String ?? ""
                    let password = user.value(forKey: "password") as? String ?? ""
                    print("User \(index + 1):")
                    print("Username: \(username)")
                    print("Phone Number: \(phoneNumber)")
                    print("Password: \(password)")
                    print("------------------------")
                }
                
            } catch let error as NSError {
                print("Could not fetch users. \(error), \(error.userInfo)")
            }
        }

    @IBAction func logInButtonTapped(_ sender: Any) {
        let password = passwordTextField.text ?? ""
            let phoneNumber = pNumberTextField.text ?? ""
                    
            if !phoneNumber.isEmpty && !password.isEmpty {
                if doesUserExist(phoneNumber: phoneNumber, password: password) {
                    // Instantiate CustomTabBarController from the storyboard
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
                    tabBarViewController.modalPresentationStyle = .fullScreen
                    self.present(tabBarViewController, animated: true, completion: nil)
                } else {
                    print("User not found. Phone number: \(phoneNumber), password: \(password)")
                }
            } else {
                print("Phone number or password is empty")
            }
    }
    
    func doesUserExist(phoneNumber: String, password: String) -> Bool {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@ AND password == %@", phoneNumber, password)

            do {
                let users = try context.fetch(fetchRequest)
                return users.count > 0
            } catch let error as NSError {
                print("Could not fetch users. \(error), \(error.userInfo)")
                return false
            }
        }
    
    func deleteAllUsers() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("All users deleted successfully")
        } catch let error as NSError {
            print("Could not delete users. \(error), \(error.userInfo)")
        }
    }
    
}

