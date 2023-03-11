//
//  ContentViewViewModel.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import Foundation

class ContentViewViewModel: ObservableObject {
    @Published var opacity: Double = 0
    @Published var sidebarOpened: Bool = false
    @Published var homeViewOpened: Bool = true
    @Published var wallScreenViewOpened: Bool = false
    @Published var wallIndex: Int = 0
    @Published var aboutViewOpened: Bool = false
    @Published var topBarOpened: Bool = true
    
    func changeOpacity(opacity: Double) {
        self.opacity = opacity
    }
    
    func toggleSidebar() {
        self.sidebarOpened = !sidebarOpened
        sidebarOpened ? self.changeOpacity(opacity: 0.75) : self.changeOpacity(opacity: 0)
    }
    
    func openSidebar() {
        self.sidebarOpened = true
        self.changeOpacity(opacity: 0.75)
    }
    
    func closeSidebar() {
        self.sidebarOpened = false
        self.changeOpacity(opacity: 0)
    }
    
    func openHomeView() {
        self.homeViewOpened = true
    }
    
    func closeHomeView() {
        self.homeViewOpened = false
    }
    
    func openWallScreenView() {
        self.wallScreenViewOpened = true
    }
    
    func closeWallScreenView() {
        self.wallScreenViewOpened = false
    }
    
    func changeWallIndex(index: Int) {
        self.wallIndex = index
    }
    
    func openAboutView() {
        self.aboutViewOpened = true
    }
    
    func closeAboutView() {
        self.aboutViewOpened = false
    }
    
    func openTopBar() {
        self.topBarOpened = true
    }
    
    func closeTopBar() {
        self.topBarOpened = false
    }
}