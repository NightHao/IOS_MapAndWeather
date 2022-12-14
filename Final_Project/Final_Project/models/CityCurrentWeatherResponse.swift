//
//  CityCurrentWeatherResponse.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import Foundation

struct CityCurrentWeatherResponse: Codable{
    let weather:[CityWeather]
    let main:CityMainTemp
    let wind:CityWind
    let clouds:CityClouds
    
}

struct CityWeather: Codable{
    let main:String
    let description:String
    let icon:String
}

struct CityMainTemp:Codable{
    let temp:Double
    let feels_like:Double
    let temp_min:Double
    let temp_max:Double
    let pressure:Double
    let humidity:Double
}

struct CityWind:Codable{
    let speed:Double?
    let deg:Double?
    let gust:Double?
}

struct CityClouds:Codable{
    let all:Int?
}
