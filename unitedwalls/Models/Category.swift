//
//  Category.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import Foundation

struct Category: Codable {
    let _id: String
    let name: String
    let walls: [Wall]
}
