//
//  Book.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import SwiftData
import SwiftUI

@Model
final class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    @Attribute(originalName: "summary")
    var synopsis: String
    var rating: Int?
    var status: Status.RawValue
    var recommendedBy: String = ""
    @Relationship(deleteRule: .cascade)
    var quotes: [Quote]?
    @Relationship(inverse: \Genre.books)
    var genres: [Genre]?
    
    var icon: Image {
        switch Status(rawValue: status)! {
        case .onShelf:
            Image(systemName: "books.vertical.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "checkmark.diamond.fill")
        }
    }
    
    init(title: String, author: String, dateAdded: Date = Date(), dateStarted: Date = Date.distantPast, dateCompleted: Date = Date.distantPast, synopsis: String = "", rating: Int? = nil, status: Status = .onShelf, recommendedBy: String = "") {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.synopsis = synopsis
        self.rating = rating
        self.status = status.rawValue
        self.recommendedBy = recommendedBy
    }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed
    
    var id: Self {self}
    
    var desc: String {
        switch self {
        case .onShelf:
            return "On Shelf"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}
