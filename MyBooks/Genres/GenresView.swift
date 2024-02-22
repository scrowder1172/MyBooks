//
//  GenresView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/15/24.
//

import SwiftData
import SwiftUI

struct GenresView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable var book: Book
    
    @Query(sort: \Genre.name) var genres: [Genre]
    
    @State private var newGenre: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if genres.isEmpty {
                    ContentUnavailableView {
                        Image(systemName: "bookmark.fill")
                            .font(.largeTitle)
                    } description: {
                        Text("You need to create some genres first.")
                    } actions: {
                        Button("Create Genre") {
                            newGenre.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        ForEach(genres) { genre in
                            HStack {
                                if let bookGenres = book.genres {
                                    if bookGenres.isEmpty {
                                        Button {
                                            addRemove(genre)
                                        } label: {
                                            Image(systemName: "circle")
                                        }
                                        .foregroundStyle(genre.hexColor)
                                    } else {
                                        Button {
                                            addRemove(genre)
                                        } label: {
                                            Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
                                        }
                                        .foregroundStyle(genre.hexColor)
                                    }
                                }
                                Text(genre.name)
                            }
                        }
                        .onDelete { indexSet in
                            deleteGenre(for: indexSet, book: book)
                        }
                        
                        LabeledContent {
                            Button {
                                newGenre.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                            }
                            .buttonStyle(.borderedProminent)
                        } label: {
                            Text("Create new Genre")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(book.title)
            .sheet(isPresented: $newGenre) {
                NewGenreView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            
        }
    }

    func deleteGenre(for offsets: IndexSet, book: Book) {
        for offset in offsets {
            
            /// Check if genre is attached to book and then remove it in order to force a refresh of the EditBookView showing the genre has been removed
            /// Without this code, the genre will still appear on the EditBookView until a  new book is selected
            /// EditBookView is not listening for changes to Genre table
            /// When Genre is added to the selected book, the addRemove() function appends the genre to the book thereby triggering a refresh of the EditBookView view
            if let bookGenres = book.genres {
                if bookGenres.contains(genres[offset]) {
                    if let bookGenreIndex = bookGenres.firstIndex(where: {$0.id == genres[offset].id}) {
                        book.genres?.remove(at: bookGenreIndex)
                    } else {
                        /// unable to determine index for genre on the selected book in order to remove the genre from the book
                    }
                } else {
                    /// selected book does not have the genre being removed
                }
            } else {
                /// selected book does not have any genres
            }
            
            let genre: Genre = genres[offset]
            modelContext.delete(genre)
        }
    }
    
    func addRemove(_ genre: Genre) {
        if let bookGenre = book.genres {
            if bookGenre.isEmpty {
                book.genres?.append(genre)
            } else {
                if bookGenre.contains(genre), let index = bookGenre.firstIndex(where: {$0.id == genre.id}) {
                    book.genres?.remove(at: index)
                } else {
                    book.genres?.append(genre)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    let preview: PreviewContainer = PreviewContainer(models: [Book.self])
    let books: [Book] = Book.sampleBooks
    let genres: [Genre] = Genre.sampleGenres
    preview.addSampleData(sampleDataItems: genres)
    preview.addSampleData(sampleDataItems: books)
    books[1].genres?.append(genres[0])
    return GenresView(book: books[1])
        .modelContainer(preview.container)
}
#endif
