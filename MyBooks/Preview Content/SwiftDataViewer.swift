//
//  SwiftDataViewer.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/15/24.
//
/// found at: https://www.youtube.com/watch?v=jCC3yuc5MUI

import Foundation
import SwiftData
import SwiftUI

struct SwiftDataViewer<Content: View>: View {
    
    private let content: Content
    private let items: [any PersistentModel]?
    private let preview: PreviewContainer
    
    init(preview: PreviewContainer, items: [any PersistentModel]? = nil, @ViewBuilder _ content: () -> Content) {
        self.preview = preview
        self.items = items
        self.content = content()
    }
    
    var body: some View {
        content
            .modelContainer(preview.container)
            .onAppear {
                if let items {
                    preview.addSampleData(sampleDataItems: items)
                }
            }
    }
}
