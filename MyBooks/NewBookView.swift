//
//  NewBookView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import SwiftUI

struct NewBookView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @State private var author: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Book Title", text: $title)
                    .textInputAutocapitalization(.words)
                TextField("Author", text: $author)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                Button("Create") {
                    let newBook: Book = Book(title: title, author: author)
                    modelContext.insert(newBook)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty || author.isEmpty)
                .navigationTitle("New Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewBookView()
}
