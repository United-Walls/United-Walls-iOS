//
//  Color.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let bgColor = Color("BGColor")
    let bgSecondaryColor = Color("BGSecondaryColor")
    let bgTertiaryColor = Color("BGTertiaryColor")
    let textColor = Color("TextColor")
}
