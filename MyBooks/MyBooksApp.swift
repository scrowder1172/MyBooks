//
//  MyBooksApp.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import SwiftData
import SwiftUI

@main
struct MyBooksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
    
    init() {
        #if DEBUG
        /// capture database file location for initial development and debugging
        print("Database file: \(URL.applicationSupportDirectory.path(percentEncoded: false))")
        #endif
    }
}
