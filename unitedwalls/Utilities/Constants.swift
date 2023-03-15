//
//  Constants.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import Foundation

struct Constants {
    static var apiURL: URL? = URL(string: "http://unitedwalls.ddns.net:5002/api/")
    static var wallApiURL: URL? = URL(string: "http://unitedwalls.ddns.net:5002/api/walls")
    static var categoryApiURL: URL? = URL(string: "http://unitedwalls.ddns.net:5002/api/category")
    static var wallByIdURLString: String = "http://unitedwalls.ddns.net:5002/api/walls/"
    static var categoryByIdURLString: String = "http://unitedwalls.ddns.net:5002/api/category/"
}
