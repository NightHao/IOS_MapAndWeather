//
//  CityResponse.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import Foundation

struct CityResponse: Codable{
    let name:String
    let local_names:localNames
    let lat:Double
    let lon:Double
    let country:String
}

struct localNames: Codable{
    let zh:String
}
