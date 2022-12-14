//
//  Place.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//
import SwiftUI
import Foundation
import MapKit

struct Place: Identifiable{
    var id = UUID().uuidString
    var place: CLPlacemark
}
struct Place_Name: Identifiable{
    let id = UUID()
    var name: String
}
