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
    let description: String?
    var walls: [Wall]
    let socialMediaLinks: SocialMediaLinks?
    let donationLinks: DonationLinks?
    let avatar_file_url: String?
}

struct SocialMediaLinks: Codable {
    let twitter: String?
    let instagram: String?
    let mastodon: String?
    let facebook: String?
    let threads: String?
    let steam: String?
    let linkedIn: String?
    let link: String?
    let other: [OtherLinks]?
}

struct DonationLinks: Codable {
    let paypal: String?
    let patreon: String?
    let otherdonations: [OtherLinks]?
}

struct OtherLinks: Codable {
    let title: String?
    let link: String?
}
