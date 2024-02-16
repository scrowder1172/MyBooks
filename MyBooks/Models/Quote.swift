//
//  Quotes.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/15/24.
//

import Foundation
import SwiftData

@Model
final class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?
    
    var book: Book?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
}
