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
    @Published var loadingCategories: Bool
    @Published var categories: [Category]
    @Published var selectedCategory: Category?
    
    init() {
        self.loadingWalls = true
        self.walls = []
        self.loadingCategories = true
        self.categories = []
        self.loadWalls()
        self.loadCategories()
    }
    
    private func loadWalls() {
        let url = Constants.wallApiURL
        if (url != nil) {
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { [self] data, res, err in
                guard err == nil && "\((res as! HTTPURLResponse).statusCode)".hasPrefix("20") else {
                    let walls: [Wall] = []
                    DispatchQueue.main.async {
                        self.walls = walls
                        self.loadingWalls = false
                    }
                    return
                }
                
                guard let data = data else {
                    let walls: [Wall] = []
                    DispatchQueue.main.async {
                        self.walls = walls
                        self.loadingWalls = false
                    }
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode([Wall].self, from: data)
                    let walls = json
                    DispatchQueue.main.async {
                        self.walls = walls
                        self.loadingWalls = false
                    }
                } catch {
                    print(error)
                    let walls: [Wall] = []
                    DispatchQueue.main.async {
                        self.walls = walls
                        self.loadingWalls = false
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
                        self.loadingCategories = false
                    }
                    return
                }
                
                guard let data = data else {
                    let categories: [Category] = []
                    DispatchQueue.main.async {
                        self.categories = categories
                        self.loadingCategories = false
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
                        self.loadingCategories = false
                    }
                    return
                }
            }
            .resume()
        }
    }
    
    func loadWallScreenWalls() {
        self.modifiedWalls = self.walls
    }
    
    func unloadWallScreenWalls() {
        self.modifiedWalls = []
    }
}
