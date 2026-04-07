//
//  DashboardView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//


import SwiftUI
import SwiftData

struct DashboardView: View {
    
    // MARK: - SwiftData Queries
    
    // Fetch all intake entries (newest first)
    @Query(sort: \IntakeEntry.timestamp, order: .reverse)
    private var entries: [IntakeEntry]
    
    // Fetch user settings (goals from onboarding)
    @Query
    private var settings: [UserSettings]
    
    
    // MARK: - Computed Properties
    
    // Only today's entries
    private var todayEntries: [IntakeEntry] {
        entries.filter { Calendar.current.isDateInToday($0.timestamp) }
    }
    
    // Total water intake today (oz)
    private var waterTotal: Double {
        todayEntries
            .filter { $0.isWater }
            .reduce(0) { $0 + $1.amountOz }
    }
    
    // Total caffeine intake today (mg)
    private var caffeineTotal: Double {
        todayEntries.reduce(0) { $0 + $1.caffeineContentMg }
    }
    
    // User goals (fallback if none saved yet)
    private var waterGoal: Double {
        settings.first?.waterGoalOz ?? 64.0
    }
    
    private var caffeineLimit: Double {
        settings.first?.caffeineLimitMg ?? 400.0
    }
    
    
    private var waterProgress: Double {
        guard waterGoal > 0 else { return 0 }
        return min(waterTotal / waterGoal, 1.0)
    }
    
    private var caffeineProgress: Double {
        guard caffeineLimit > 0 else { return 0 }
        return min(caffeineTotal / caffeineLimit, 1.0)
    }
    
    // MARK: - State
    @State private var isShowingLogModal = false
    
    // MARK: - UI
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - Progress Rings
                HStack(spacing: 40) {
                    ProgressRingView(
                        progress: waterProgress,
                        color: .blue,
                        icon: "drop.fill",
                        label: "Water",
                        value: "\(String(format: "%.0f", waterTotal)) / \(String(format: "%.0f", waterGoal)) oz"
                    )
                    
                    ProgressRingView(
                        progress: caffeineProgress,
                        color: .brown,
                        icon: "cup.and.saucer.fill",
                        label: "Caffeine",
                        value: "\(String(format: "%.0f", caffeineTotal)) / \(String(format: "%.0f", caffeineLimit)) mg"
                    )
                }
                .padding(.vertical, 20)
                
                
                // MARK: - Today's Intake List
                List {
                    Section(header: Text("Today's Intake")) {
                        
                        // Empty state
                        if todayEntries.isEmpty {
                            Text("No intake logged yet today.")
                                .foregroundColor(.secondary)
                        } else {
                            
                            // Real entries from database
                            ForEach(todayEntries) { entry in
                                HStack {
                                    
                                    
                                    Image(systemName: entry.isWater ? "drop.fill" : "cup.and.saucer.fill")
                                        .foregroundColor(entry.isWater ? .blue : .brown)
                                        .frame(width: 30)
                                    
                                   
                                    VStack(alignment: .leading) {
                                        Text(entry.beverageName)
                                            .font(.headline)
                                        
                                        Text(entry.formattedTime)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    
                                    Text(
                                        entry.isWater
                                        ? String(format: "%.0f oz", entry.amountOz)
                                        : String(format: "%.0f mg", entry.caffeineContentMg)
                                    )
                                    .fontWeight(.bold)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            
            // MARK: - Navigation
            
            .navigationTitle("Dashboard")
            
            // Add button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingLogModal = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isShowingLogModal) {
                LogEntryView()
            }
        }
    }
}


// MARK: - Preview

#Preview {
    DashboardView()
        .modelContainer(for: [UserSettings.self, IntakeEntry.self], inMemory: true)
}
