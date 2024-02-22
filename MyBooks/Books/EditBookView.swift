//
//  EditBookView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/14/24.
//

import SwiftData
import SwiftUI

struct EditBookView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let book: Book
    
    @State private var status: Status = .onShelf
    @State private var rating: Int?
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var synopsis: String = ""
    @State private var dateAdded: Date = Date.distantPast
    @State private var dateStarted: Date = Date.distantPast
    @State private var dateCompleted: Date = Date.distantPast
    @State private var recommendedBy: String = ""
    
    @State private var firstView: Bool = true
    @State private var showGenres: Bool = false
    
    var changed: Bool {
        status.rawValue != book.status
        || rating != book.rating
        || title != book.title
        || author != book.author
        || synopsis != book.synopsis
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
        || recommendedBy != book.recommendedBy
    }
    
    var body: some View {
        HStack {
            Text("Status")
            
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.desc)
                        .tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $dateAdded, in: ...Date.now, displayedComponents: .date)
                } label: {
                    Text("Date Added")
                }
                
                if status == .inProgress || status == .completed {
                    
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded...Date.now, displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                
                if status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateStarted...Date.now, displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if !firstView {
                    print("firstView => false")
                    if newValue == .onShelf {
                        /// Book put back on shelf to read
                        dateStarted = Date.distantPast
                        dateCompleted = Date.distantPast
                        print("Status change: newValue = onShelf")
                    } else if newValue == .inProgress && oldValue == .completed {
                        /// Book restarted
                        dateStarted = Date.now
                        dateCompleted = Date.distantPast
                        print("Status change: newValue = inProgress, oldValue = completed")
                    } else if newValue == .inProgress && oldValue == .onShelf {
                        /// Book started
                        dateStarted = Date.now
                        print("Status change: newValue = inProgress, oldValue = onShelf")
                    } else if newValue == .completed && oldValue == .onShelf {
                        /// Book completed but forgot to mark as in progress
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                        print("Status change: newValue = completed, oldValue = onshelf")
                    } else {
                        /// Book completed
                        dateCompleted = Date.now
                        print("Status change: newValue = completed")
                    }
                } else {
                    firstView = false
                    print("Set firstView => false")
                }
            }
            
            Divider()
            
            LabeledContent {
                RatingsView(maxRating: 5, currentRating: $rating, width: 30)
            } label: {
                Text("Rating")
            }
            
            LabeledContent {
                TextField("", text: $title)
            } label: {
                Text("Title")
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $author)
            } label: {
                Text("Author")
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $recommendedBy)
            } label: {
                Text("Recommended By")
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            Text("Synopsis")
                .foregroundStyle(.secondary)
            TextEditor(text: $synopsis)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2)
                )
            if let genres: [Genre] = book.genres {
                ViewThatFits {
                    GenreStackView(genres: genres)
                    ScrollView(.horizontal, showsIndicators: false) {
                        GenreStackView(genres: genres)
                    }
                }
            }
            
            HStack{
                Button("Genres", systemImage: "bookmark.fill") {
                    showGenres.toggle()
                }
                .sheet(isPresented: $showGenres) {
                    GenresView(book: book)
                }
                NavigationLink {
                    QuotesListView(book: book)
                } label: {
                    let count = book.quotes?.count ?? 0
                    Label("^[\(count) Quotes](inflect: true)", systemImage: "quote.opening")
                    
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            if changed {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Update") {
                        book.status = status.rawValue
                        book.rating = rating
                        book.title = title
                        book.author = author
                        book.synopsis = synopsis
                        book.dateAdded = dateAdded
                        book.dateStarted = dateStarted
                        book.dateCompleted = dateCompleted
                        book.recommendedBy = recommendedBy
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(changed ? "Cancel" : "Back") {
                    dismiss()
                }
            }
        }
        .onAppear {
            status = Status(rawValue: book.status)!
            if status == .onShelf {
                firstView = false
            }
            rating = book.rating
            title = book.title
            author = book.author
            synopsis = book.synopsis
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
            recommendedBy = book.recommendedBy
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        SwiftDataViewer(preview: PreviewContainer(models: [Book.self])) {
            EditBookView(book: Book.sampleBooks.randomElement()!)
        }
    }
}
#endif
