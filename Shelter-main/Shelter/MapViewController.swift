//
//  MapViewController.swift
//  Shelter
//
//  Created by Jismi Jesmani on 5/2/23.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        setupLocationManager()
        
        // Fetch all professionals
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Professionals")

            do {
                let professionals = try managedContext.fetch(fetchRequest) as! [Professionals]
                for professional in professionals {
                    guard let name = professional.name, let address = professional.address else {
                        continue
                    }
                    addAnnotationForAddress(address, title: name)
                }
            } catch let error as NSError {
                print("Could not fetch professionals. \(error), \(error.userInfo)")
            }
    }
    
    private func setupMapView() {
        // Add mapView as a subview
        view.addSubview(mapView)

        // Set mapView's constraints to fill the entire view controller's view
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let regionRadius: CLLocationDistance = 1000 // Meters
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius,
                                                      longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            locationManager.stopUpdatingLocation() // Stop updating location after setting the initial region
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
    
    func addAnnotationForAddress(_ address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard error == nil, let placemark = placemarks?.first, let location = placemark.location else {
                print("Error geocoding address: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = title
            self.mapView.addAnnotation(annotation)
        }
    }

}
