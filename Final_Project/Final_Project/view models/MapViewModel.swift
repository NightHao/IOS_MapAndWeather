//
//  MapViewModel.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var mapView = MKMapView()
    @Published var region : MKCoordinateRegion!
    @Published var permissionDenied = false
    @Published var mapType : MKMapType = .standard
    @Published var searchTxt = ""
    @Published var places : [Place] = []
    func updateMapType(){
        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
        }
        else{
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    func focusLocation(){
        guard let _ = region else{return}
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    func searchQuery(){
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTxt
        
        MKLocalSearch(request: request).start{ (response, _) in
            guard let result = response else{return}
            self.places = result.mapItems.compactMap({(item) -> Place? in
                return Place(place: item.placemark)
            })
            
        }
    }
    
    func selectPlace(place: Place){
        searchTxt = ""
        
        guard let coordinate = place.place.location?.coordinate else{return}
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "No Name"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnnotation)
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    func navigation(place: Place){
        guard let nav_coordinate = place.place.location?.coordinate else{return}
        let targetLocation = CLLocationCoordinate2D(latitude: nav_coordinate.latitude, longitude: nav_coordinate.longitude)
        let targetPlacemark=MKPlacemark(coordinate: targetLocation)
        let targetItem = MKMapItem(placemark: targetPlacemark)
        let userMapItem=MKMapItem.forCurrentLocation()
        let routes=[userMapItem,targetItem]
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .denied:
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        guard let location = locations.last else{return}
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapView.setRegion(self.region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
