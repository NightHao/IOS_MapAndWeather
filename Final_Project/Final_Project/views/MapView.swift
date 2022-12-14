//
//  MapView.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var mapData: MapViewModel
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    func makeUIView(context: Context) -> some UIView {
        let view = mapData.mapView
        view.showsUserLocation = true
        view.delegate = context.coordinator
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    class Coordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation.isKind(of: MKUserLocation.self){return nil}
            else{
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.tintColor = .red
                pinAnnotation.animatesDrop = true
                pinAnnotation.canShowCallout = true
                
                return pinAnnotation
            }
        }
    }
}

