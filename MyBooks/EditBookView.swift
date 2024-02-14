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
    @State private var summary: String = ""
    @State private var dateAdded: Date = Date.distantPast
    @State private var dateStarted: Date = Date.distantPast
    @State private var dateCompleted: Date = Date.distantPast
    
    @State private var firstView: Bool = true
    
    var changed: Bool {
        status != book.status
        || rating != book.rating
        || title != book.title
        || author != book.author
        || summary != book.summary
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
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
                    if newValue == .onShelf {
                        /// Book put back on shelf to read
                        dateStarted = Date.distantPast
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .completed {
                        /// Book restarted
                        dateStarted = Date.now
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .onShelf {
                        /// Book started
                        dateStarted = Date.now
                    } else if newValue == .completed && oldValue == .onShelf {
                        /// Book completed but forgot to mark as in progress
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                    } else {
                        /// Book completed
                        dateCompleted = Date.now
                    }
                    firstView = false
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
            
            Divider()
            
            Text("Summary")
                .foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2)
                )
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Update") {
                    book.status = status
                    book.rating = rating
                    book.title = title
                    book.author = author
                    book.summary = summary
                    book.dateAdded = dateAdded
                    book.dateStarted = dateStarted
                    book.dateCompleted = dateCompleted
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status = book.status
            rating = book.rating
            title = book.title
            author = book.author
            summary = book.summary
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
        }
    }
}

#Preview {
    do {
        let config: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container: ModelContainer = try ModelContainer(for: Book.self, configurations: config)
        let book: Book = Book(title: "Sample Data", author: "Pete Peterson")
        return NavigationStack{
            EditBookView(book: book)
        }
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
