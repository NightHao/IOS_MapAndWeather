//
//  City.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import Foundation

class City:ObservableObject{
    @Published var cityName:String
    
    init(){
        cityName=""
    }
}

