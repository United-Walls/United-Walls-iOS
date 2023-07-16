//
//  unitedwallsApp.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import UserMessagingPlatform

@main
struct unitedwallsApp: App {
    @StateObject var apiManager = ApiManager()
    @StateObject var contentViewViewModel: ContentViewViewModel = ContentViewViewModel()
    @StateObject var favouriteWallsStore = FavouriteWallsStore()
    @StateObject var privacyPolicyStore = PrivacyPolicyStore()
    @StateObject var networkMonitor = NetworkMonitor()
    
    init() {
        print(UIScreen.main.nativeBounds.height)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.theme.textColor)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.theme.bgColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.textColor)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.textColor)], for: .normal)
        
        requestIDFA()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apiManager)
                .environmentObject(contentViewViewModel)
                .environmentObject(favouriteWallsStore)
                .environmentObject(privacyPolicyStore)
                .environmentObject(networkMonitor)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.requestIDFA()
                    }
                    
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
    
    private func initGoogleMobileAds() {
        GADMobileAds.sharedInstance()
            .start(completionHandler: nil)
    }
    
    private func requestIDFA() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                  ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                      switch status {
                      case .notDetermined:
                          break
                      default:
                          self.showConsentInformation()
                      }
                      
              })
        })
    }
        
    private func showConsentInformation() {
        let parameters = UMPRequestParameters()
        
        // false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { error in
                if error != nil {
                    // Handle the error.
                } else {
                    // The consent information state was updated.
                    // You are now ready to check if a form is
                    // available.
                    self.loadForm()
                }
            })
        
    }
        
    func loadForm() {
        UMPConsentForm.load(
            completionHandler: { form, loadError in
                if loadError != nil {
                    // Handle the error
                } else {
                    // Present the form
                    if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
                        form?.present(from: UIApplication.shared.windows.first!.rootViewController! as UIViewController, completionHandler: { dimissError in
                            if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                                // App can start requesting ads.
                                self.initGoogleMobileAds()
                            }
                        })
                    }
                }
            })
    }
}
