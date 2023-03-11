//
//  UIImage.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-11.
//

import Foundation
import SwiftUI

extension UIImage {
    var jpeg: Data? { jpegData(compressionQuality: 1) }  // QUALITY min = 0 / max = 1
    var png: Data? { pngData() }
}

extension Data {
    var uiImage: UIImage? { UIImage(data: self) }
}
