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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    var userLocation: CLLocation?
    var currentRoute: MKRoute?
    var goButton: UIButton?
    var selectedAnnotation: ProfessionalAnnotation?

    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        setupLocationManager()
        //setupBackButton()
        let backButton = UIButton(type: .system)
            backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            backButton.setTitle("Back", for: .normal)
            backButton.contentHorizontalAlignment = .leading
            backButton.semanticContentAttribute = .forceLeftToRight
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

            self.view.addSubview(backButton)

            backButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
                backButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        
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
                    addAnnotationForAddress(address, professional: professional)
                }

            } catch let error as NSError {
                print("Could not fetch professionals. \(error), \(error.userInfo)")
            }
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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
        
        mapView.delegate = self
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
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
    
    func addAnnotationForAddress(_ address: String, professional: Professionals) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard error == nil, let placemark = placemarks?.first, let location = placemark.location else {
                print("Error geocoding address: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let annotation = ProfessionalAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = professional.name
            annotation.address = professional.address
            annotation.expertise = professional.expertise
            annotation.phoneNumber = professional.phoneNumber
            
            self.mapView.addAnnotation(annotation)
            
            if let userLocation = self.userLocation {
                self.calculateWalkingRoute(from: userLocation.coordinate, to: location.coordinate) { (route, error) in
                    if let distance = route?.distance {
                        DispatchQueue.main.async {
                            let distanceInKm = distance / 1000
                            annotation.subtitle = String(format: "Walking distance: %.2f km", distanceInKm)
                            self.mapView.removeAnnotation(annotation)
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }




    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't change the user location annotation
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "ProfessionalAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        // Customize the callout
        if let professionalAnnotation = annotation as? ProfessionalAnnotation {
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = UIFont.systemFont(ofSize: 12)
            detailLabel.text = """
            Address: \(professionalAnnotation.address ?? "")
            Expertise: \(professionalAnnotation.expertise ?? "")
            Phone: \(professionalAnnotation.phoneNumber ?? "")
            \(professionalAnnotation.subtitle ?? "")
            """
            annotationView?.detailCalloutAccessoryView = detailLabel
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(annotationTapped(_:)))
            annotationView?.addGestureRecognizer(tapGestureRecognizer)
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }


    func calculateWalkingRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping (MKRoute?, Error?) -> Void) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let error = error {
                completion(nil, error)
            } else if let route = response?.routes.first {
                completion(route, nil)
            } else {
                completion(nil, nil)
            }
        }
    }


    @objc func annotationTapped(_ sender: UITapGestureRecognizer) {
        guard let annotationView = sender.view as? MKAnnotationView,
              let professionalAnnotation = annotationView.annotation as? ProfessionalAnnotation,
              let userCoordinate = userLocation?.coordinate else {
            return
        }

        // Remove the previously displayed route, if any
        if let currentRoute = currentRoute {
            mapView.removeOverlay(currentRoute.polyline)
        }

        // Calculate the walking route
        calculateWalkingRoute(from: userCoordinate, to: professionalAnnotation.coordinate) { [weak self] (route, error) in
            if let route = route {
                self?.currentRoute = route
                self?.mapView.addOverlay(route.polyline)
                self?.showGoButton()
            } else {
                print("Error calculating walking route: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func showGoButton() {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])

        goButton = button
    }
    
    func hideGoButton() {
        goButton?.removeFromSuperview()
        goButton = nil
    }
    
    @objc func goButtonTapped() {
        guard let selectedAnnotation = selectedAnnotation else { return }
        let placemark = MKPlacemark(coordinate: selectedAnnotation.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = selectedAnnotation.title

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]
        mapItem.openInMaps(launchOptions: launchOptions)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let professionalAnnotation = view.annotation as? ProfessionalAnnotation else { return }
        selectedAnnotation = professionalAnnotation
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideGoButton()
        selectedAnnotation = nil
    }
    
//    private func setupBackButton() {
//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
//        navigationItem.leftBarButtonItem = backButton
//    }
//
//    @objc func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
}
