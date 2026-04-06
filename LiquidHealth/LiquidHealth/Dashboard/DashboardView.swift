//
//  DashboardView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//

import SwiftUI

struct MockIntakeEntry: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let isWater: Bool
    let time: String
}

struct DashboardView: View {
    // Placeholder data
    let todayLogs = [
        MockIntakeEntry(
            name: "Morning Chug",
            amount: 16.0,
            isWater: true,
            time: "8:00 AM"
        ),
        MockIntakeEntry(
            name: "Black Coffee",
            amount: 8.0,
            isWater: false,
            time: "9:30 AM"
        ),
        MockIntakeEntry(
            name: "Gym Hydroflask",
            amount: 24.0,
            isWater: true,
            time: "12:15 PM"
        ),
        MockIntakeEntry(
            name: "Espresso Shot",
            amount: 2.0,
            isWater: false,
            time: "2:00 PM"
        ),
    ]

    var body: some View {
        NavigationStack {
            VStack {
                // Progress Rings Section
                HStack(spacing: 40) {
                    ProgressRingView(
                        progress: 0.62,
                        color: .blue,
                        icon: "drop.fill",
                        label: "Water",
                        value: "40 / 64 oz"
                    )
                    ProgressRingView(
                        progress: 0.45,
                        color: .brown,
                        icon: "cup.and.saucer.fill",
                        label: "Caffeine",
                        value: "180 / 400 mg"
                    )
                }
                .padding(.vertical, 20)

                // SwiftUI List for Logs
                List {
                    Section(header: Text("Today's Intake")) {
                        ForEach(todayLogs) { log in
                            HStack {
                                // Dynamic icon based on drink type
                                Image(
                                    systemName: log.isWater
                                        ? "drop.fill" : "cup.and.saucer.fill"
                                )
                                .foregroundColor(log.isWater ? .blue : .brown)
                                .frame(width: 30)

                                VStack(alignment: .leading) {
                                    Text(log.name)
                                        .font(.headline)
                                    Text(log.time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                // Amount formatting
                                Text(
                                    "\(log.amount, specifier: "%.0f") \(log.isWater ? "oz" : "mg")"
                                )
                                .fontWeight(.bold)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Dashboard")

            // Toolbar Item (Add Drink Button)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Toggle modal state variable here later
                        print("Add button tapped!")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
