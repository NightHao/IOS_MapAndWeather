//
//  Final_ProjectApp.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/2.
//

import SwiftUI
import FacebookCore
@main
struct Final_ProjectApp: App {
    init() {
            ApplicationDelegate.shared.application(UIApplication.shared)
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                }
        }
    }
}
