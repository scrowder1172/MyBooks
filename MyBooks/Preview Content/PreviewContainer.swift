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
    
    init(models: [any PersistentModel.Type], isStoredInMemoryOnly: Bool = true) {
        let config: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        let schema: Schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create preview container")
        }
    }
    
    func addSampleData(sampleDataItems: [any PersistentModel]) {
        Task { @MainActor in
            sampleDataItems.forEach { sample in
                container.mainContext.insert(sample)
            }
        }
    }
}
