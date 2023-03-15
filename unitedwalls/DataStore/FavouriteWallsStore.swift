//
//  FavouriteWalls.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-13.
//

import Foundation
import SwiftUI

class FavouriteWallsStore: ObservableObject {
    @Published var walls: [String] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("favouritewalls.unitedwalls")
    }
    
    static func load(completion: @escaping (Result<[String], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let favouriteWalls = try JSONDecoder().decode([String].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(favouriteWalls))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(walls: [String], completion: @escaping (Result<Int, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(walls)
            let outfile = try fileURL()
            try data.write(to: outfile)
            DispatchQueue.main.async {
                completion(.success(walls.count))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
