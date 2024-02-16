//
//  Genre.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/15/24.
//

import SwiftData
import SwiftUI

@Model
final class Genre {
    var name: String
    var color: String
    var books: [Book]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    var hexColor: Color {
        Color(hex: self.color) ?? .red
    }
}
