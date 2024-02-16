//
//  QuotesListView.swift
//  MyBooks
//
//  Created by SCOTT CROWDER on 2/15/24.
//

import SwiftData
import SwiftUI

struct QuotesListView: View {
    
    @Environment(\.modelContext) var modelContext
    
    let book: Book
    
    @State private var text: String = ""
    @State private var page: String = ""
    @State private var selectedQuote: Quote?
    
    var isEditing: Bool {
        selectedQuote != nil
    }
    
    var body: some View {
        GroupBox {
            HStack {
                LabeledContent("Page") {
                    TextField("page #", text: $page)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    Spacer()
                }
                
                if isEditing {
                    Button("Cancel") {
                        page = ""
                        text = ""
                        selectedQuote = nil
                    }
                    .buttonStyle(.bordered)
                }
                
                Button(isEditing ? "Update" : "Create") {
                    if isEditing {
                        selectedQuote?.text = text
                        selectedQuote?.page = page.isEmpty ? nil : page
                        page = ""
                        text = ""
                        selectedQuote = nil
                    } else {
                        let quote: Quote = page.isEmpty ? Quote(text: text) : Quote(text: text, page: page)
                        book.quotes?.append(quote)
                        text = ""
                        page = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(text.isEmpty)
            }
            
            TextEditor(text: $text)
                .border(.secondary)
                .frame(height: 100)
        }
        .padding(.horizontal)
        
        List {
            let sortedQuotes: [Quote] = book.quotes?.sorted(using: KeyPathComparator(\Quote.creationDate)) ?? []
            ForEach(sortedQuotes) { quote in
                VStack(alignment: .leading) {
                    Text(quote.creationDate, format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(quote.text)
                    
                    HStack {
                        Spacer()
                        if let page = quote.page, !page.isEmpty {
                            Text("Page: \(page)")
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedQuote = quote
                    text = quote.text
                    page = quote.page ?? ""
                }
            }
            .onDelete(perform: deleteQuote)
        }
        .listStyle(.plain)
        .navigationTitle("Quotes")
    }
    
    func deleteQuote(for offsets: IndexSet) {
        withAnimation {
            for offset in offsets {
                if let quote: Quote = book.quotes?[offset] {
                    modelContext.delete(quote)
                }
            }
        }
    }
}

#Preview("PreviewContainer") {
    let previewContainer: PreviewContainer = PreviewContainer(models: [Book.self])
    let books: [Book] = Book.sampleBooks
    previewContainer.addSampleData(sampleDataItems: books)
    return NavigationStack {
        QuotesListView(book: books[4])
            .navigationBarTitleDisplayMode(.inline)
            .modelContainer(previewContainer.container)
    }
}

#Preview("SwiftDataView (broken)") {
    NavigationStack{
        SwiftDataViewer(preview: PreviewContainer(models: [Book.self]), items: Book.sampleBooks) {
            QuotesListView(book: Book.sampleBooks[4])
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
