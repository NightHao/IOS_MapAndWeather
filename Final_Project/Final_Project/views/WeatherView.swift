//
//  WeatherView.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import SwiftUI
import CoreLocation
extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

struct WeatherView: View {
    
    //@StateObject var weatherNews = NewsSearchViewModel()
    @StateObject var locationManager = LocationManager() //取得座標
    //@StateObject var locationManager = MapViewModel()
    @StateObject var cityViewModel = CityViewModel() //把座標轉成城市的API
    
    @StateObject var cityWeatherForecastViewModel = CityWeatherForecastViewModel() //中央氣象局的預報API
    
    @StateObject var cityCurrentWeatherViewModel = CityCurrentWeatherViewModel() //open Weather的目前天氣API
    
    @State var requestingLocation = false
    @State var showWebpage = false
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        VStack{
            
            if(requestingLocation){
                GetLocationView(requestingLocation: $requestingLocation, cityViewModel: cityViewModel,cityForecastViewModel: cityWeatherForecastViewModel,cityCurrentWeatherViewModel: cityCurrentWeatherViewModel).environmentObject(locationManager)
            }else{
                
                List {
                    Section(header:Text("目前天氣")){
                        
                        //Text("Test")
                        if let cityCurrentWeather = cityCurrentWeatherViewModel.currentWeather{
                            CurrentWeatherRow(cityCurrentWeather: cityCurrentWeather).gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                                                                .onEnded({ value in
                                if value.translation.width < 0 {
                                    // 向左滑
                                    if let url = URL(string: "https://www.cwb.gov.tw/V8/C/") {
                                           UIApplication.shared.open(url)
                                        }
                                }
                                
                                if value.translation.width > 0 {
                                    // 向右滑
                                    if let url = URL(string: "https://openweathermap.org/") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                
                            }))
                            
                            
                        }else{
                            Text("loading...")
                        }
                        HStack{
                            Text("城市天氣：\(cityViewModel.cityList[cityViewModel.selectCityIndex])")
                            Button {
                                requestingLocation = true
                            } label: {
                                Text("更改城市").offset(x:70)
                            }
                        }.offset(x:17)
                    }
                    Link("詳細天氣", destination: URL(string: "https://www.cwb.gov.tw/V8/C/")!).offset(x:120)
                    
                    ForEach(cityWeatherForecastViewModel.weatherRecord) { item in
                        let timeslices_brief = item.weatherElement[0].time
                        let timeslices_PoP = item.weatherElement[1].time
                        let timeslices_minTemp = item.weatherElement[2].time
                        let timeslices_description = item.weatherElement[3].time
                        let timeslices_maxTemp = item.weatherElement[4].time
                        ForEach(timeslices_brief.indices){
                            j in
                            Section(header: Text("\((j)*6)～\((j+1)*6)小時內的天氣")){
                               // let weather_info = timeslices_brief[j].parameter.parameterName+" - "+timeslices_description[j]
                                Text("\(timeslices_brief[j].parameter.parameterName): \(timeslices_description[j].parameter.parameterName)")
                                
                                Text("溫度: \(timeslices_minTemp[j].parameter.parameterName) ~ \(timeslices_maxTemp[j].parameter.parameterName)°C")
                                Text("降雨機率: "+timeslices_PoP[j].parameter.parameterName+"%")
                                
                            }
                            
            
                        }
                        
                    }
                    if(idiom != .pad){
                        Button(action: shareButton) {
                            Label("分享", systemImage: "square.and.arrow.up")
                        }
                    }
                }.overlay{
                    if(cityWeatherForecastViewModel.weatherRecord.isEmpty){
                        ProgressView()
                    }
                }.refreshable {
                    cityWeatherForecastViewModel.fetchItems(locationStr: cityViewModel.cityList[cityViewModel.selectCityIndex])
                    cityCurrentWeatherViewModel.fetchItems(locationStr: cityViewModel.cityEngList[cityViewModel.selectCityIndex])
                }
                
                
                

            }
            
        }.onAppear {
            if let location = locationManager.lastLocation{

                cityViewModel.fetchItems(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
            cityViewModel.updateIndex()
            cityWeatherForecastViewModel.fetchItems(locationStr: cityViewModel.cityList[cityViewModel.selectCityIndex])
            cityCurrentWeatherViewModel.fetchItems(locationStr: cityViewModel.cityEngList[cityViewModel.selectCityIndex])
        }
        
        
    }
    
    func shareButton() {
            let url = URL(string: "https://www.cwb.gov.tw/V8/C/")
        
            let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

            UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
