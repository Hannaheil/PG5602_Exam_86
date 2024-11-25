//
//  Item.swift
//  YourNews
//
//  Created by Hannah Eilertsen on 25/11/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
