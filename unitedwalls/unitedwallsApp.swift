//
//  unitedwallsApp.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI

@main
struct unitedwallsApp: App {
    @StateObject var apiManager = ApiManager()
    @StateObject var contentViewViewModel: ContentViewViewModel = ContentViewViewModel()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.theme.textColor)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.theme.bgColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.textColor)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.textColor)], for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apiManager)
                .environmentObject(contentViewViewModel)
        }
    }
}
