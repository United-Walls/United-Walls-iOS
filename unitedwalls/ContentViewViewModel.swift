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
    @Published var favouriteWallScreenViewOpened: Bool = false
    @Published var wallIndex: Int = 0
    @Published var aboutViewOpened: Bool = false
    @Published var topBarOpened: Bool = true
    @Published var favouriteWallsViewOpened: Bool = false
    @Published var categoriesViewOpened: Bool = false
    @Published var categoryViewOpened: Bool = false
    @Published var categoryWallScreenViewOpened: Bool = false
    @Published var sidebarOffset: CGFloat = 0
    @Published var mostLikedScreenOpened: Bool = false
    @Published var mostLikedWallScreenViewOpened: Bool = false
    @Published var mostPopularScreenOpened: Bool = false
    @Published var mostPopularWallScreenViewOpened: Bool = false
    @Published var uploadersViewOpened: Bool = false
    @Published var uploaderViewOpened: Bool = false
    @Published var uploaderWallScreenViewOpened: Bool = false
    
    func changeOffset(offset: CGFloat) {
        sidebarOffset = offset
    }
    
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
        print(self.sidebarOpened)
    }
    
    func closeSidebar() {
        self.sidebarOpened = false
        self.changeOpacity(opacity: 0)
        print(self.sidebarOpened)
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
    
    func openFavouriteWallScreenView() {
        self.favouriteWallScreenViewOpened = true
    }
    
    func closeFavouriteWallScreenView() {
        self.favouriteWallScreenViewOpened = false
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
    
    func openFavouriteWalls() {
        self.favouriteWallsViewOpened = true
    }
    
    func closeFavouriteWalls() {
        self.favouriteWallsViewOpened = false
    }
    
    func openCategoriesView() {
        self.categoriesViewOpened = true
    }
    
    func closeCategoriesView() {
        self.categoriesViewOpened = false
    }
    
    func openCategoryView() {
        self.categoryViewOpened = true
    }
    
    func closeCategoryView() {
        self.categoryViewOpened = false
    }
    
    func openCategoryWallScreenView() {
        self.categoryWallScreenViewOpened = true
    }
    
    func closeCategoryWallScreenView() {
        self.categoryWallScreenViewOpened = false
    }
    
    func openMostLikedScreenView() {
        print("Opened Most Liked Screen View")
        self.mostLikedScreenOpened = true
    }
    
    func closeMostLikedScreenView() {
        self.mostLikedScreenOpened = false
    }
    
    func openMostLikedWallScreenView() {
        self.mostLikedWallScreenViewOpened = true
    }
    
    func closeMostLikedWallScreenView() {
        self.mostLikedWallScreenViewOpened = false
    }
    
    func openMostPopularScreenView() {
        self.mostPopularScreenOpened = true
    }
    
    func closeMostPopularScreenView() {
        self.mostPopularScreenOpened = false
    }
    
    func openMostPopularWallScreenView() {
        self.mostPopularWallScreenViewOpened = true
    }
    
    func closeMostPopularWallScreenView() {
        self.mostPopularWallScreenViewOpened = false
    }
    
    func openUploadersScreenView() {
        self.uploadersViewOpened = true
    }
    
    func closeUploadersScreenView() {
        self.uploadersViewOpened = false
    }
    
    func openUploaderScreenView() {
        self.uploaderViewOpened = true
    }
    
    func closeUploaderScreenView() {
        self.uploaderViewOpened = false
    }
    
    func openUploaderWallScreenView() {
        self.uploaderWallScreenViewOpened = true
    }
    
    func closeUploaderWallScreenView() {
        self.uploaderWallScreenViewOpened = false
    }
}
