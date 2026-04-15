//
//  HistoryView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//


import SwiftUI
import SwiftData
import Charts

struct DailyIntakeData: Identifiable {
    let id = UUID()
    let date: Date
    let totalOz: Double
    let totalCaffeineMg: Double
    let waterGoalOz: Double
    let caffeineLimitMg: Double
    
    var dayLabel: String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }
}

enum ChartMode {
    case water
    case caffeine
}

// Main History screen displaying a list of intake logs grouped by date
struct HistoryView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    // Fetch all intake entries (newest first)
    @Query(sort: \IntakeEntry.timestamp, order: .reverse)
    private var entries: [IntakeEntry]
    
    // Fetch user settings (used for daily water goal)
    @Query
    private var settings: [UserSettings]
    
    // UI State for Chart Toggle
    @State private var chartMode: ChartMode = .water
        
    // Caffeine limit default to 400 mg if no user settings exist yet
    private var caffeineLimit: Double {
        settings.first?.caffeineLimitMg ?? 400.0
    }
    
    // Default to 64 oz if no user settings exist yet
    private var waterGoal: Double {
        settings.first?.waterGoalOz ?? 64.0
    }
    
    // Aggregates total intake for the last 7 days for BOTH water and coffee metrics
    private var weeklyData: [DailyIntakeData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<7).reversed().map { offset in
            let day = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            
            // Get all entries for this specific day
            let daysEntries = entries.filter { calendar.isDate($0.timestamp, inSameDayAs: day) }
            
            let totalWater = daysEntries.filter { $0.isWater }.reduce(0) { $0 + $1.amountOz }
            let totalCaffeine = daysEntries.reduce(0) { $0 + $1.caffeineContentMg }
            
            return DailyIntakeData(
                date: day,
                totalOz: totalWater,
                totalCaffeineMg: totalCaffeine,
                waterGoalOz: waterGoal,
                caffeineLimitMg: caffeineLimit
            )
        }
    }
    
    // Groups entries by date (Today, Yesterday, or formatted date)
    private var groupedEntries: [(key: String, value: [IntakeEntry])] {
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
    private func deleteEntries(at offsets: IndexSet, in sectionEntries: [IntakeEntry]) {
        let itemsToDelete = offsets.map { sectionEntries[$0] }
        for entry in itemsToDelete {
            modelContext.delete(entry)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Weekly Analytics Chart
                Section("Weekly Analytics") {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Picker("Chart Metric", selection: $chartMode) {
                            Text("Water").tag(ChartMode.water)
                            Text("Caffeine").tag(ChartMode.caffeine)
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom, 4)

                        Chart {
                            ForEach(weeklyData) { day in
                                BarMark(
                                    x: .value("Day", day.dayLabel),
                                    y: .value("Intake", chartMode == .water ? day.totalOz : day.totalCaffeineMg)
                                )
                                .foregroundStyle(chartMode == .water ? .blue : .brown)

                                RuleMark(
                                    y: .value("Goal/Limit", chartMode == .water ? day.waterGoalOz : day.caffeineLimitMg)
                                )
                                .foregroundStyle((chartMode == .water ? Color.blue : Color.brown).opacity(0.4))
                            }
                        }
                        .frame(height: 220)

                        Text(chartMode == .water ? "Goal: \(Int(waterGoal)) oz per day" : "Limit: \(Int(caffeineLimit)) mg per day")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }

                // MARK: - History List
                if entries.isEmpty {
                    Section("History") {
                        Text("No intake history yet.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    ForEach(groupedEntries, id: \.key) { section in
                        Section(section.key) {
                            ForEach(section.value) { entry in
                                HStack(spacing: 16) {
                                    Image(systemName: entry.isWater ? "drop.fill" : "cup.and.saucer.fill")
                                        .foregroundColor(entry.isWater ? .blue : .brown)
                                        .font(.title3)
                                        .frame(width: 24)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(entry.beverageName)
                                            .font(.headline)

                                        HStack(spacing: 6) {
                                            Text("\(Int(entry.amountOz)) oz")
                                            
                                            if !entry.isWater {
                                                Text("•")
                                                Text("\(Int(entry.caffeineContentMg)) mg")
                                                    .foregroundColor(.brown)
                                            }
                                        }
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
                            .onDelete { offsets in
                                deleteEntries(at: offsets, in: section.value)
                            }
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
        .modelContainer(for: [UserSettings.self, IntakeEntry.self], inMemory: true)

}
