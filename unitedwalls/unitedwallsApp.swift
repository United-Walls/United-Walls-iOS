//
//  unitedwallsApp.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

@main
struct unitedwallsApp: App {
    @StateObject var apiManager = ApiManager()
    @StateObject var contentViewViewModel: ContentViewViewModel = ContentViewViewModel()
    @StateObject var favouriteWallsStore = FavouriteWallsStore()
    @StateObject var privacyPolicyStore = PrivacyPolicyStore()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.theme.textColor)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.theme.bgColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.textColor)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.textColor)], for: .normal)
        
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                    //User has not indicated their choice for app tracking
                    //You may want to show a pop-up explaining why you are collecting their data
                    //Toggle any variables to do this here
        } else {
            ATTrackingManager.requestTrackingAuthorization { status in
                //Whether or not user has opted in initialize GADMobileAds here it will handle the rest
                                                            
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apiManager)
                .environmentObject(contentViewViewModel)
                .environmentObject(favouriteWallsStore)
                .environmentObject(privacyPolicyStore)
                .onAppear {
                    FavouriteWallsStore.load { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let walls):
                            favouriteWallsStore.walls = walls
                        }
                    }
                }
        }
    }
}
