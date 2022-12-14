//
//  Home.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import SwiftUI
import CoreLocation

struct Home: View {
    @StateObject var mapData = MapViewModel()
    @State var locationManager = CLLocationManager()
    @State var nav_place = false
    @State var tmp_places: [Place] = []
    @Binding var my_places: [Place]
    @Binding var my_place_name:[Place_Name]
    var body: some View {
        ZStack{
            MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                VStack(spacing: 0) {
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $mapData.searchTxt)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)
                
                    if !mapData.places.isEmpty && mapData.searchTxt != ""{
                        ScrollView{
                            VStack(spacing: 15){
                                ForEach(mapData.places) {place in
                                    Text(place.place.name ?? "")
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .onTapGesture {
                                            tmp_places.removeAll()
                                            tmp_places.append(place)
                                            nav_place = true
                                            mapData.selectPlace(place: place)
                                        }
                                    Divider()
                                }
                            }
                            .padding(.top)
                        }
                        .background(Color.white)
                    }
                }
                .padding()
                Spacer()
                VStack{
                    if nav_place == true{
                        VStack{
                            Button(action: {
                                mapData.navigation(place: tmp_places[0])
                                nav_place = false
                            }, label: {
                                Image(systemName: "car.fill")
                                    .font(.title2)
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            })
                            Button(action: {
                                my_places.append(tmp_places[0])
                                my_place_name.append(Place_Name(name: tmp_places[0].place.name ?? "No Name"))
                                
                                print(my_place_name)
                            }, label: {
                                Image(systemName: "folder.circle.fill")
                                    .font(.title2)
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            })
                        }
                    }
                    Button(action: mapData.focusLocation, label:{
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                    })
                    
                    Button(action: mapData.updateMapType, label:{
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
        }.onAppear(perform: {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        /*.onAppear(perform: {
            if nav_place == true{
                Button(action: {
                    mapData.navigation(place: tmp_places[0])
                    nav_place = false
                }, label: {
                    Text("導航")
                })
            }
        })*/
        .alert(isPresented: $mapData.permissionDenied, content:{
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Goto Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchTxt, perform:{value in
            let delay = 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delay){
                if value == mapData.searchTxt{
                    self.mapData.searchQuery()
                }
            }
        })
    }
}

/*struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(my_places: .constant(1), my_place_name: .constant(1))
    }
}*/
