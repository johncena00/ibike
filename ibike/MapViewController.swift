//
//  MapViewController.swift
//  ibike
//
//  Created by devilcry on 2016/7/31.
//  Copyright © 2016年 devilcry. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var segmentControl:UISegmentedControl!
    
    var ibikes:ibike!
    
    let locationManager = CLLocationManager()
    var currentPlacemark:CLPlacemark?
    var currentRoute:MKRoute?
    var currentTransportType = MKDirectionsTransportType.automobile

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.isHidden = true
        
        // Request for a user's authorization for location services
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }

        mapView.delegate = self
        
        let geoCoder = CLGeocoder()
        
        let lat = Double(ibikes.lat)
        let lon = Double(ibikes.lon)
        
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: lat!, longitude: lon!), completionHandler: {
            (placemarks,error) -> Void in
            
            if error != nil{
                print(error)
                return
            }
            
            //name         街道地址
            //country      國家
            //province     省
            //locality     市
            //sublocality  縣.區
            //route        街道、路
            //streetNumber 門牌號碼
            //postalCode   郵遞區號
            if placemarks != nil && placemarks!.count > 0{
                let placemark = placemarks![0] as CLPlacemark
                
                // 地標位置
                self.currentPlacemark = placemark
                //這邊拼湊轉回來的地址
                //placemark.name
                
                // Add Annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.ibikes.name
                annotation.coordinate = placemark.location!.coordinate
                
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
                
            }
        })
        
        // Convert address to coordinate and annotate it on map
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(ibikes.location, completionHandler: { placemarks, error in
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            if placemarks != nil && placemarks!.count > 0 {
//                let placemark = placemarks![0]
//                
//                // Add Annotation
//                let annotation = MKPointAnnotation()
//                annotation.title = self.ibikes.name
//                annotation.subtitle = self.ibikes.empty
//                annotation.coordinate = placemark.location!.coordinate
//                
//                self.mapView.showAnnotations([annotation], animated: true)
//                self.mapView.selectAnnotation(annotation, animated: true)
//                
//            }
//            
//        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showNearBy(_ sender:AnyObject) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = "Cafe"
        searchRequest.region = mapView.region
        
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                
                return
            }
            
            let mapItems = response.mapItems
            var nearbyAnnotations:[MKAnnotation] = []
            if mapItems.count > 0 {
                for item in mapItems {
                    // Add annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    if let location = item.placemark.location {
                        annotation.coordinate = location.coordinate
                    }
                    
                    nearbyAnnotations.append(annotation)
                }
            }
            
            self.mapView.showAnnotations(nearbyAnnotations, animated: true)
        }
    }
    
    @IBAction func showDirection(_ sender:AnyObject) {
       
        // Get the selected transport type
        switch segmentControl.selectedSegmentIndex {
        case 0: currentTransportType = MKDirectionsTransportType.automobile
        case 1: currentTransportType = MKDirectionsTransportType.walking
        default: break
        }
        
        segmentControl.isHidden = false
        
        
        let directionRequest = MKDirectionsRequest()
        
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (routeResponse, routeError) -> Void in
            
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                
                return
            }
            
            let route = routeResponse.routes[0]
            self.currentRoute = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
//        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
//        leftIconView.image = UIImage(named: restaurant.image)!
//        annotationView?.leftCalloutAccessoryView = leftIconView
        
        // Pin color customization
        if #available(iOS 9.0, *) {
            annotationView?.pinTintColor = UIColor.orange
        }
        
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "showSteps", sender: view)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSteps" {
            let routeTableViewController = segue.destination
            as! RouteTableViewController
            
       
            if let steps = currentRoute?.steps {
                routeTableViewController.routeSteps = steps
            }
        }
    }
    

}
