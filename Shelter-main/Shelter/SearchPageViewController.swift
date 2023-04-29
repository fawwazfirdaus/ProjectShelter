//
//  SearchPageViewController.swift
//  Shelter
//
//  Created by FSE394 on 4/29/23.
//

import Foundation
import UIKit

class SearchPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var firstDropDownOptions = ["Professional Mentors", "Support Groups", "Clinics"]
    var secondDropDownOptions = ["10 miles", "20 miles", "30 miles"]

    var selectedDropDown: UIButton?

    @IBOutlet var firstDropDownButton: UIButton!
    @IBOutlet var secondDropDownButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    
    var firstDropDownTableView: UITableView!
    var secondDropDownTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton(button: firstDropDownButton, title: "Select Option")
        configureButton(button: secondDropDownButton, title: "Select Option")
        
        initializeDropDownTableView()
        configureButtons()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        positionDropDownTableView()
    }

    func configureButton(button: UIButton, title: String) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left

        let chevronImage = UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysTemplate)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let attachment = NSTextAttachment()
        attachment.image = chevronImage
        attachment.bounds = CGRect(x: 0, y: -2, width: attachment.image!.size.width, height: attachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: attachment)
        
        attributedTitle.append(NSAttributedString(string: "     ")) // Add some spacing
        attributedTitle.append(attachmentString)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func initializeDropDownTableView() {
        let tableViewWidth: CGFloat = 335
        let tableViewHeight: CGFloat = 135

        firstDropDownTableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight), style: .plain)
        secondDropDownTableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight), style: .plain)

        [firstDropDownTableView, secondDropDownTableView].forEach { tableView in
            guard let tableView = tableView else { return }
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.layer.cornerRadius = 10
            tableView.layer.masksToBounds = true
            tableView.isHidden = true
            self.view.addSubview(tableView)
        }
    }
    
    func positionDropDownTableView() {
        let buttonHeight: CGFloat = 135
        
        if let firstButtonFrame = firstDropDownButton.superview?.convert(firstDropDownButton.frame, to: self.view) {
            firstDropDownTableView.frame.origin = CGPoint(x: firstButtonFrame.minX, y: firstButtonFrame.maxY)
        }

        if let secondButtonFrame = secondDropDownButton.superview?.convert(secondDropDownButton.frame, to: self.view) {
            secondDropDownTableView.frame.origin = CGPoint(x: secondButtonFrame.minX, y: secondButtonFrame.maxY)
        }
        
        firstDropDownTableView.frame.size.height = buttonHeight
        secondDropDownTableView.frame.size.height = buttonHeight
    }




    @IBAction func firstDropDownButtonTapped(_ sender: UIButton) {
        firstDropDownTableView.isHidden = !firstDropDownTableView.isHidden
        secondDropDownTableView.isHidden = true
        selectedDropDown = firstDropDownButton
        firstDropDownTableView.reloadData()
        let buttonFrame = sender.convert(sender.bounds, to: view)
        firstDropDownTableView.frame.origin = CGPoint(x: buttonFrame.minX, y: buttonFrame.maxY)
    }

    @IBAction func secondDropDownButtonTapped(_ sender: UIButton) {
        secondDropDownTableView.isHidden = !secondDropDownTableView.isHidden
        firstDropDownTableView.isHidden = true
        selectedDropDown = secondDropDownButton
        secondDropDownTableView.reloadData()
        let buttonFrame = sender.convert(sender.bounds, to: view)
        secondDropDownTableView.frame.origin = CGPoint(x: buttonFrame.minX, y: buttonFrame.maxY)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedDropDown == firstDropDownButton {
            return firstDropDownOptions.count
        } else if selectedDropDown == secondDropDownButton {
            return secondDropDownOptions.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if selectedDropDown == firstDropDownButton {
            cell.textLabel?.text = firstDropDownOptions[indexPath.row]
        } else if selectedDropDown == secondDropDownButton {
            cell.textLabel?.text = secondDropDownOptions[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedDropDown == firstDropDownButton {
            configureButton(button: firstDropDownButton, title: firstDropDownOptions[indexPath.row])
        } else if selectedDropDown == secondDropDownButton {
            configureButton(button: secondDropDownButton, title: secondDropDownOptions[indexPath.row])
        }
        
        tableView.isHidden = true
    }
    
    func configureButtons() {
        let fontSize: CGFloat = 16 // Replace '20' with your desired font size
        let font = UIFont(name: "Inter-SemiBold", size: fontSize)
    
        searchButton.layer.cornerRadius = 25
        searchButton.clipsToBounds = true
            
        let title = "Search"
        let attributedTitle = NSAttributedString(string: title, attributes: [.font: font!])
        searchButton.setAttributedTitle(attributedTitle, for: .normal)
    }

}
