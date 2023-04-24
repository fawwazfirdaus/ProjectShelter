//
//  FindProfessionalsNearMe.swift
//  Shelter
//
//  Created by Jismi Jesmani on 4/23/23.
//

import Foundation
import UIKit
import CoreData

class FindProfessionalsNearMe: UIViewController{
    
    @IBOutlet var searchResultLabel: UILabel!
    @IBOutlet var searchResultView: UIView!
    @IBOutlet var professionalsTableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        searchResultLabel.text = "Search Result"
        searchResultLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        searchResultView.layer.cornerRadius = 30 // Change this value to adjust the corner radius
        searchResultView.layer.masksToBounds = true
        
        
        professionalsTableView.layer.cornerRadius = 30
        professionalsTableView.layer.masksToBounds = true
    }
    
    /*func fetchProfessionals() {
        // Get a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Professionals>(entityName: "Professionals")
        
        do {
            professionals = try managedContext.fetch(fetchRequest)
            professionalsTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch professionals. \(error), \(error.userInfo)")
        }
    }
    
    func addProfessional(name: String, phoneNumber: String, address: String, expertise: String) {
        // Get a reference to the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Professionals", in: managedContext)!
        let professional = NSManagedObject(entity: entity, insertInto: managedContext) as! Professionals
        
        professional.name = name
        professional.phoneNumber = phoneNumber
        professional.address = address
        professional.expertise = expertise
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save the professional. \(error), \(error.userInfo)")
        }
    }
     */

}
