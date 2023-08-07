//
//  ApiManager.swift
//  United Walls
//
//  Created by Paras KCD on 2023-03-05.
//

import Foundation

class ApiManager: ObservableObject {
    @Published var loadingWalls: Bool
    @Published var walls: [Wall]
    @Published var modifiedWalls: [Wall] = []
    @Published var modifiedFavouriteWalls: [Wall] = []
    @Published var favouriteWalls: [Wall] = []
    @Published var loadingCategories: Bool
    @Published var categories: [Category]
    @Published var selectedCategory: Category?
    @Published var modifiedSelectedCategoryWalls: [Wall] = []
    @Published var wallTotalCount: Int = 0
    @Published var uploaderWallsTotalCount: Int = 0
    @Published var categoryWallsTotalCount: Int = 0
    @Published var mostFavouritedWalls: [Wall] = []
    @Published var mostDownloadedWalls: [Wall] = []
    @Published var wallOfDay: Wall? = nil
    private var page = 0
    @Published var uploaders: [Uploader]
    @Published var selectedUploader: Uploader?
    
    @Published var addedBy = ""
    
    init() {
        self.loadingWalls = true
        self.walls = []
        self.loadingCategories = true
        self.categories = []
        self.uploaders = []
        self.loadWalls(initialize: true)
        self.loadCategories()
        self.loadWallCount()
        self.loadMostDownloadedWalls()
        self.loadMostFavouritedWalls()
        self.loadWallOfDay()
        self.loadUploaders()
    }
    
    func loadUploaderById(userId: String, initialize: Bool) {
        loadUploaderWallCount(userId: userId)
        
        if initialize == true {
            self.page = 0
            self.selectedUploader = nil
        }
        
        
        if let url = URL(string: "https://unitedwalls.paraskcd.com/api/uploaders/walls/queries?userId=\(userId)&page=\(self.page)") {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    DispatchQueue.main.async {
                        self.selectedUploader = nil
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.selectedUploader = nil
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Uploader.self, from: data)
                    DispatchQueue.main.async {
                        if initialize {
                            self.selectedUploader = json
                        } else {
                            if self.selectedUploader != nil {
                                self.selectedUploader!.walls.append(contentsOf: json.walls)
                            }
                        }
                        self.page += 1
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        self.selectedUploader = nil
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func loadUploaderFromWallId(wallId: String) {
        self.addedBy = ""
        if let url = URL(string: "https://unitedwalls.paraskcd.com/api/uploaders/wall?wallId=\(wallId)") {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    DispatchQueue.main.async {
                        self.addedBy = ""
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.addedBy = ""
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Uploader.self, from: data)
                    DispatchQueue.main.async {
                        self.addedBy = json.username
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        self.addedBy = ""
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func loadUploaders() {
        if let url = URL(string: "https://unitedwalls.paraskcd.com/api/uploaders") {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    DispatchQueue.main.async {
                        self.uploaders = []
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.uploaders = []
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode([Uploader].self, from: data)
                    DispatchQueue.main.async {
                        self.uploaders.append(contentsOf: json)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        self.uploaders = []
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func loadWallOfDay() {
        let url = URL(string: "https://unitedwalls.paraskcd.com/api/walls/wallOfDay")
        if url != nil {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    DispatchQueue.main.async {
                        self.wallOfDay = nil
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.wallOfDay = nil
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Wall.self, from: data)
                    DispatchQueue.main.async {
                        self.wallOfDay = json
                    }
                } catch {
                    print(error)
                    return
                }
            }
            .resume()
        }
    }
    
    func addToServer(wallId: String, api: String) {
        let url = URL(string: "https://unitedwalls.paraskcd.com/api/walls/\(api)?wallId=\(wallId)")
        if url != nil {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    print("Success")
                } catch {
                    print(error)
                    return
                }
            }
            .resume()
        }
    }
    
    func loadMostFavouritedWalls() {
        self.mostFavouritedWalls = []
        let url = URL(string: "https://unitedwalls.paraskcd.com/api/walls/mostFavourited")
        if url != nil {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    let mostFavouritedWalls: [Wall] = []
                    DispatchQueue.main.async {
                        self.mostFavouritedWalls = mostFavouritedWalls
                    }
                    return
                }
                
                guard let data = data else {
                    let mostFavouritedWalls: [Wall] = []
                    DispatchQueue.main.async {
                        self.mostFavouritedWalls = mostFavouritedWalls
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode([Wall].self, from: data)
                    DispatchQueue.main.async {
                        self.mostFavouritedWalls.append(contentsOf: json)
                        self.loadingWalls = false
                    }
                } catch {
                    print(error)
                    let mostFavouritedWalls: [Wall] = []
                    DispatchQueue.main.async {
                        self.mostFavouritedWalls = mostFavouritedWalls
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func loadMostDownloadedWalls() {
        self.mostDownloadedWalls = []
        let url = URL(string: "https://unitedwalls.paraskcd.com/api/walls/mostDownloaded")
        if url != nil {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    let mostDownloadedWalls: [Wall] = []
                    DispatchQueue.main.async {
                        self.mostDownloadedWalls = mostDownloadedWalls
                    }
                    return
                }
                
                guard let data = data else {
                    let mostDownloadedWalls: [Wall] = []
                    DispatchQueue.main.async {
                        self.mostDownloadedWalls = mostDownloadedWalls
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode([Wall].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.mostDownloadedWalls.append(contentsOf: json)
                        self.loadingWalls = false
                    }
                } catch {
                    print(error)
                    let mostDownloadedWalls: [Wall] = []
                    DispatchQueue.main.async {
                        self.mostDownloadedWalls = mostDownloadedWalls
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func loadWallCount() {
        let url = URL(string: "https://unitedwalls.paraskcd.com/api/walls/count")
        if (url != nil) {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Int.self, from: data)
                    DispatchQueue.main.async {
                        self.wallTotalCount = json
                    }
                    
                } catch {
                    print(error)
                    return
                }
            }
            .resume()
        }
    }
    
    func loadUploaderWallCount(userId: String) {
        self.uploaderWallsTotalCount = 0
        if let url = URL(string: "https://unitedwalls.paraskcd.com/api/uploaders/walls/count?userId=\(userId)") {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [self] data, res, err in 
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    self.uploaderWallsTotalCount = 0
                    return
                }
                
                guard let data = data else {
                    self.uploaderWallsTotalCount = 0
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Int.self, from: data)
                    DispatchQueue.main.async {
                        self.uploaderWallsTotalCount = json
                    }
                } catch {
                    print(error)
                    return
                }
            }
        }
    }
    
    func loadCategoryWallCount(categoryId: String) {
        self.categoryWallsTotalCount = 0
        if let url = URL(string: "https://unitedwalls.paraskcd.com/api/category/walls/count?categoryId=\(categoryId)") {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    self.categoryWallsTotalCount = 0
                    return
                }
                
                guard let data = data else {
                    self.categoryWallsTotalCount = 0
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Int.self, from: data)
                    DispatchQueue.main.async {
                        self.categoryWallsTotalCount = json
                    }
                } catch {
                    print(error)
                    return
                }
            }
        }
    }
    
    func loadWalls(initialize: Bool?) {
        if initialize == true {
            self.page = 0
            self.walls = []
        }
        self.loadingWalls = true
        let url = URL(string: "https://unitedwalls.paraskcd.com/api/walls/queries?page=\(self.page)")
        if (url != nil) {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    let walls: [Wall] = []
                    DispatchQueue.main.async {
                        self.walls = walls
                    }
                    return
                }
                
                guard let data = data else {
                    let walls: [Wall] = []
                    DispatchQueue.main.async {
                        self.walls = walls
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode([Wall].self, from: data)
                    DispatchQueue.main.async {
                        self.walls.append(contentsOf: json)
                        self.loadingWalls = false
                        self.page += 1
                    }
                } catch {
                    print(error)
                    let walls: [Wall] = []
                    DispatchQueue.main.async {
                        self.walls = walls
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    private func loadCategories() {
        let url = Constants.categoryApiURL
        if (url != nil) {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    let categories: [Category] = []
                    DispatchQueue.main.async {
                        self.categories = categories
                    }
                    return
                }
                
                guard let data = data else {
                    let categories: [Category] = []
                    DispatchQueue.main.async {
                        self.categories = categories
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode([Category].self, from: data)
                    let categories = json
                    DispatchQueue.main.async {
                        self.categories = categories
                        self.loadingCategories = false
                    }
                } catch {
                    print(error)
                    let categories: [Category] = []
                    DispatchQueue.main.async {
                        self.categories = categories
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func loadWallScreenSelectedCategoryWalls(walls: [Wall]) {
        self.modifiedSelectedCategoryWalls = walls
    }
    
    func unloadWallScreenSelectedCategoryWalls() {
        self.modifiedSelectedCategoryWalls = []
    }
    
    func loadWallScreenFavouriteWalls(walls: [Wall]) {
        self.modifiedFavouriteWalls = walls
    }
    
    func unloadWallScreenFavouriteWalls() {
        self.modifiedFavouriteWalls = []
    }
    
    func loadWallScreenWalls(walls: [Wall]) {
        self.modifiedWalls = walls
    }
    
    func unloadWallScreenWalls() {
        self.modifiedWalls = []
    }
    
    func loadFavouriteWalls(wallIds: [String]) {
        self.favouriteWalls = []
        for id in wallIds {
            let url = URL(string: "https://unitedwalls.paraskcd.com/api/walls/\(id)")
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Wall.self, from: data)
                    DispatchQueue.main.async {
                        self.favouriteWalls.append(json)
                    }
                } catch {
                    print(error)
                    return
                }
            }
            .resume()
        }
    }
    
    func unloadFavouriteWalls() {
        self.favouriteWalls = []
    }
    
    func loadCategory(category: Category) {
        self.selectedCategory = category
    }
    
    func loadCategoryById(categoryId: String, initialize: Bool) {
        loadCategoryWallCount(categoryId: categoryId)
        
        if initialize == true {
            self.page = 0
            self.selectedCategory = nil
        }
        
        
        if let url = URL(string: "https://unitedwalls.paraskcd.com/api/category/walls/queries?categoryId=\(categoryId)&page=\(self.page)") {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    DispatchQueue.main.async {
                        self.selectedCategory = nil
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.selectedCategory = nil
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(Category.self, from: data)
                    DispatchQueue.main.async {
                        if initialize {
                            print(json)
                            self.selectedCategory = json
                        } else {
                            if self.selectedCategory != nil {
                                self.selectedCategory!.walls.append(contentsOf: json.walls)
                            }
                        }
                        self.page += 1
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        self.selectedCategory = nil
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func unloadCategory() {
        self.selectedCategory = nil
    }
    
    func unloadCreator() {
        self.selectedUploader = nil
    }
}
