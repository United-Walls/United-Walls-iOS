//
//  Wall.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import Foundation
import SwiftUI

struct Wall: Codable {
    let _id: String
    let category: String
    let createdAt: String
    let file_id: String
    let thumbnail_id: String
    let file_name: String
    let file_url: String
    let thumbnail_url: String
    let mime_type: String
    let updatedAt: String
    let addedBy: String
    let creator: String
}
