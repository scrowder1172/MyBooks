//
//  ContentView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import SwiftData
import SwiftUI

enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, author
    
    var id: Self {self}
}

struct BookListView: View {
    @State private var createNewBook: Bool = false
    
    @State private var sortOrder: SortOrder = SortOrder.status
    @State private var filter: String = ""
    
    var body: some View {
        NavigationStack {
            
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort By \(sortOrder.rawValue)")
                        .tag(sortOrder)
                }
            }
            .buttonStyle(.bordered)
            
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: Text("Filter on title or author"))
                .navigationTitle("My Books")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            createNewBook = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $createNewBook) {
                    NewBookView()
                        .presentationDetents([.medium])
                }
        }
    }
}

#Preview("Book List Empty") {
    SwiftDataViewer(preview: PreviewContainer(models: [Book.self])) {
        BookListView()
    }
}

#Preview("Book List") {
    SwiftDataViewer(preview: PreviewContainer(models: [Book.self]), items: Book.sampleBooks) {
        BookListView()
    }
}

#Preview("Books with Genres") {
    let preview: PreviewContainer = PreviewContainer(models: [Book.self])
    let books: [Book] = Book.sampleBooks
    let genres: [Genre] = Genre.sampleGenres
    preview.addSampleData(sampleDataItems: books)
    preview.addSampleData(sampleDataItems: genres)
    return BookListView()
        .modelContainer(preview.container)
}
