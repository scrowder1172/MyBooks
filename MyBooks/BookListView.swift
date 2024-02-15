//
//  ContentView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import SwiftData
import SwiftUI

struct BookListView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Book.title) private var books: [Book]
    
    @State private var createNewBook: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if books.isEmpty {
                    ContentUnavailableView("Enter your first book", systemImage: "book.fill")
                } else {
                    List {
                        ForEach(books) { book in
                            NavigationLink {
                                EditBookView(book: book)
                            } label: {
                                HStack(spacing: 10) {
                                    book.icon
                                    
                                    VStack(alignment: .leading) {
                                        Text(book.title)
                                            .font(.headline)
                                        Text(book.author)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        if let rating = book.rating {
                                            HStack {
                                                ForEach(1..<rating, id: \.self) { _ in
                                                    Image(systemName: "star.fill")
                                                        .imageScale(.small)
                                                        .foregroundStyle(.yellow)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteBook)
                    }
                    .listStyle(.plain)
                }
            }
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
    
    func deleteBook(for offsets: IndexSet) {
        for offset in offsets {
            let book: Book = books[offset]
            modelContext.delete(book)
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
