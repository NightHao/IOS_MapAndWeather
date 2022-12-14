//
//  NoNetworkView.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import SwiftUI

struct NoNetworkView: View {
    @ObservedObject var networkMonitor:NetworkMonitor
    var body: some View {
        
        VStack {
            Image(systemName: "wifi.exclamationmark").resizable().scaledToFit().frame(width: 300, alignment: .center).padding()
            Text("沒有網路連線").font(.title)
        }.refreshable {
            
        }
        
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    static var networkMonitorTemp = NetworkMonitor()
    static var previews: some View {
        NoNetworkView(networkMonitor: networkMonitorTemp)
    }
}
