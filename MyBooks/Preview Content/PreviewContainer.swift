//
//  PreviewContainer.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import Foundation
import SwiftData

struct PreviewContainer {
    let container: ModelContainer
    
    init(_ models: [any PersistentModel.Type]) {
        let config: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema: Schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create preview container")
        }
    }
    
    func addExamples(_ examples: [any PersistentModel]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}
