//
//  BookList.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/15/24.
//

import SwiftData
import SwiftUI

struct BookList: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var books: [Book]
    
    init(sortOrder: SortOrder, filterString: String) {
        let sortDescriptors: [SortDescriptor<Book>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        case .title:
            [SortDescriptor(\Book.title)]
        case .author:
            [SortDescriptor(\Book.author)]
        }
        
        let predicate: Predicate = #Predicate<Book> { book in
            book.title.localizedStandardContains(filterString)
            || book.author.localizedStandardContains(filterString)
            || filterString.isEmpty
        }
        
        _books = Query(filter: predicate, sort: sortDescriptors)
    }
    
    var body: some View {
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
                                    .foregroundStyle(book.status == 0 ? .blue : book.status == 1 ? .green : .secondary)
                                
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
                                    if let genres: [Genre] = book.genres {
                                        ViewThatFits {
                                            GenreStackView(genres: genres)
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                GenreStackView(genres: genres)
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
    }
    
    func deleteBook(for offsets: IndexSet) {
        for offset in offsets {
            let book: Book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    NavigationStack{
        SwiftDataViewer(preview: PreviewContainer(models: [Book.self]), items: Book.sampleBooks) {
            BookList(sortOrder: .status, filterString: "")
        }
    }
}
