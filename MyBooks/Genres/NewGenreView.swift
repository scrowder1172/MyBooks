//
//  NewGenreView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/16/24.
//

import SwiftData
import SwiftUI

struct NewGenreView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var color: Color = Color.red
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                ColorPicker("Set the genre color", selection: $color, supportsOpacity: false)
                
                Button("Create") {
                    let newGenre: Genre = Genre(name: name, color: color.toHexString()!)
                    modelContext.insert(newGenre)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(name.isEmpty)
            }
            .padding()
            .navigationTitle("New Genre")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#if DEBUG
#Preview {
    SwiftDataViewer(preview: PreviewContainer(models: [Book.self])) {
        NewGenreView()
    }
}
#endif
