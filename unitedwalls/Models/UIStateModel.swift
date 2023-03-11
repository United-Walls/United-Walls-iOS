//
//  UIStateModel.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-10.
//

import Foundation

public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
}
