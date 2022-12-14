//
//  ContentView.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import SwiftUI
import CoreLocation
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
//var my_places: [Place] = []
//var my_place_name:[Place_Name] = []

struct ContentView: View {
    @StateObject var networkMonitor = NetworkMonitor()
    @State private var showAlert = false
    @State var openWeb = false
    @State var my_places: [Place] = []
    @State var my_place_name:[Place_Name] = []
    //let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var pageTitle = ""
    @State var pageUrl = URL(string: "www.google.com")!
    
    var body: some View {
        
            if(networkMonitor.status == .connected){
                
                TabView {
                    Home(my_places: $my_places, my_place_name: $my_place_name).tabItem{
                        Label("地圖", systemImage: "globe")
                    }
                    
                    WeatherView().tabItem {
                        Label("天氣",systemImage: "cloud.fill")
                    }
                    FolderView(my_places: $my_places, my_place_name: $my_place_name).tabItem {
                        Label("地點",systemImage: "heart.fill")
                    }
                }.onOpenURL { URL in
                    pageUrl = URL
                    //                let theUrl = URL.absoluteString
                    //                let splittedUrl = theUrl.split(separator: "，")
                    //                let realUrl = splittedUrl[0]
                    //                let realTitle = splittedUrl[1]
                    //                self.selectedNews = SelectedNews(url: String(realUrl), title: String(realTitle))
                    openWeb = true
                }.sheet(isPresented: $openWeb, onDismiss: {
                    pageTitle = ""
                },content: {
                    //WebView(urlStr: $0)
                    //Text("AAAAA\(pageTitle)")
                    /*if(!pageTitle.isEmpty){
                     Button(action: addItem) {
                     Label("收藏", systemImage: "plus")
                     }.padding()
                     }*/
                    
                    
                    
                })
            }else{
                NoNetworkView(networkMonitor: networkMonitor).onAppear {
                    showAlert=true
                }.alert("No connection", isPresented: $showAlert, actions: {
                    Button("OK") { }
                })
            }
            
    }
    
    /*private func addItem() {
        withAnimation {
            let newItem = SavedNews(context: viewContext)
            newItem.saveTime = Date()
            newItem.title = pageTitle
            newItem.url = pageUrl.absoluteString
            print(newItem)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }*/
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

