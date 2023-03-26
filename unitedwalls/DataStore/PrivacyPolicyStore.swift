//
//  PrivacyPolicy.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-26.
//

import Foundation
import SwiftUI

class PrivacyPolicyStore: ObservableObject {
    @Published var accepted: Bool = false
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("privacyPolicy.unitedwalls")
    }
    
    static func load(completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(false))
                    }
                    return
                }
                let accepted = try JSONDecoder().decode(Bool.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(accepted))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(accepted: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(accepted)
            let outfile = try fileURL()
            try data.write(to: outfile)
            DispatchQueue.main.async {
                completion(.success(accepted))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
