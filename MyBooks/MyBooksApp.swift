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
    
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
//        .modelContainer(for: Book.self)
        .modelContainer(container)
    }
    
    init() {
        let schema: Schema = Schema([Book.self])
        let config: ModelConfiguration = ModelConfiguration("MyBooks", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
//        let config: ModelConfiguration = ModelConfiguration(url: URL.documentsDirectory.appending(path: "MyBooks.store"))
//        do {
//            container = try ModelContainer(for: Book.self, configurations: config)
//        } catch {
//            fatalError("Could not configure the container")
//        }
        
        #if DEBUG
        /// capture database file location for initial development and debugging
        print("Database file: \(URL.applicationSupportDirectory.path(percentEncoded: false))")
//        print(URL.documentsDirectory.path())
        #endif
    }
}
