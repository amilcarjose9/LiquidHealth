//
//  HistoryView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//


import SwiftUI

// Model for a single history entry (mock data for now)
struct HistoryEntry: Identifiable {
    let id = UUID()
    let title: String
    let amount: String
    let timestamp: Date
}

// Main History screen displaying a list of intake logs grouped by date
struct HistoryView: View {
    
    // Temporary mock data (will be replaced with real data later)
    @State private var entries: [HistoryEntry] = [
        HistoryEntry(title: "Water", amount: "500 ml", timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()),
        HistoryEntry(title: "Juice", amount: "250 ml", timestamp: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date()),
        HistoryEntry(title: "Protein Shake", amount: "300 ml", timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
    ]

    // Groups entries by date (Today, Yesterday, or formatted date)
    private var groupedEntries: [(key: String, value: [HistoryEntry])] {
        // Group entries by section title based on timestamp
        let grouped = Dictionary(grouping: entries) { entry in
            sectionTitle(for: entry.timestamp)
        }

        return grouped
            .map { (key: $0.key, value: $0.value.sorted { $0.timestamp > $1.timestamp }) }
            .sorted { lhs, rhs in
                let lhsDate = lhs.value.first?.timestamp ?? .distantPast
                let rhsDate = rhs.value.first?.timestamp ?? .distantPast
                return lhsDate > rhsDate
            }
    }

    // Returns section title based on date (Today, Yesterday, or formatted date)
    private func sectionTitle(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(.dateTime.month(.abbreviated).day().year())
        }
    }

    // Formats time for display (e.g., 3:45 PM)
    private func timeText(for date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }

    // Handles swipe-to-delete functionality for entries
    private func deleteEntries(at offsets: IndexSet, in sectionEntries: [HistoryEntry]) {
        let idsToDelete = offsets.map { sectionEntries[$0].id }
        entries.removeAll { idsToDelete.contains($0.id) }
    }

    var body: some View {
        // Main navigation container
        NavigationStack {
            // List displaying grouped history entries
            List {
                // Loop through each section (grouped by date)
                ForEach(groupedEntries, id: \.key) { section in
                    // Section header (Today, Yesterday, or specific date)
                    Section(section.key) {
                        // Loop through each entry in the section
                        ForEach(section.value) { entry in
                            // Row layout for each history item
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.title)
                                        .font(.headline)
                                    Text(entry.amount)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(timeText(for: entry.timestamp))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        // Enables swipe-to-delete for each section
                        .onDelete { offsets in
                            deleteEntries(at: offsets, in: section.value)
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
}
