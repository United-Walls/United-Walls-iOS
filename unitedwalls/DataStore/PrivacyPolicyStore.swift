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
    
    init() {
        self.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let accepted):
                self.accepted = accepted
            }
        }
    }
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("privacyPolicy.unitedwalls")
    }
    
    func load(completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try self.fileURL()
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
    
    func save(accepted: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(accepted)
            let outfile = try self.fileURL()
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
