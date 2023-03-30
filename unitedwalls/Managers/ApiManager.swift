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
    private var page = 0
    
    init() {
        self.loadingWalls = true
        self.walls = []
        self.loadingCategories = true
        self.categories = []
        self.loadWalls(initialize: true)
        self.loadCategories()
        self.loadWallCount()
    }
    
    func loadWallCount() {
        let url = URL(string: "http://unitedwalls.paraskcd.com/api/walls/count")
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
                    self.wallTotalCount = json
                } catch {
                    print(error)
                    return
                }
            }
            .resume()
        }
    }
    
    func loadWalls(initialize: Bool?) {
        if initialize == true {
            self.page = 0
            self.walls = []
        }
        self.loadingWalls = true
        let url = URL(string: "http://unitedwalls.paraskcd.com/api/walls/queries?page=\(self.page)")
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
    
    private func loadWallById(wallId: String) -> Wall? {
        guard let index = self.walls.firstIndex(where: {$0._id == wallId}) else {
            return nil
        }
        return self.walls[index]
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
            guard let wall = loadWallById(wallId: id) else {
                break
            }
            self.favouriteWalls.append(wall)
        }
    }
    
    func unloadFavouriteWalls() {
        self.favouriteWalls = []
    }
    
    func loadCategory(category: Category) {
        self.selectedCategory = category
    }
    
    func unloadCategory() {
        self.selectedCategory = nil
    }
}
