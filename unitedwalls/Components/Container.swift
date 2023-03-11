//
//  Component.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-09.
//

import SwiftUI

struct Container<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
        }
        .padding(18)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.theme.bgColor)
        .cornerRadius(18)
        .padding(12)
        .shadow(radius: 20, x: 3, y: 12)
    }
}
