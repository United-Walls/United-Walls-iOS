//
//  Constants.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import Foundation

struct Constants {
    static var apiURL: URL? = URL(string: "http://unitedwalls.paraskcd.com/api/")
    static var wallApiURL: URL? = URL(string: "http://unitedwalls.paraskcd.com/api/walls")
    static var categoryApiURL: URL? = URL(string: "http://unitedwalls.paraskcd.com/api/category")
    static var wallByIdURLString: String = "http://unitedwalls.paraskcd.com/api/walls/"
    static var categoryByIdURLString: String = "http://unitedwalls.paraskcd.com/api/category/"
}
