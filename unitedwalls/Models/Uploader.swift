//
//  Uploader.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-07-14.
//

import Foundation
import SwiftUI

struct Uploader: Codable {
    let _id: String
    let userID: Int
    let username: String
    var walls: [Wall]
    let avatar_file_url: String?
}
