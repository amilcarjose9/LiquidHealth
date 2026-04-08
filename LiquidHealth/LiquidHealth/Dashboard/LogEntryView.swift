//
//  LogEntryView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/7/26.
//

import SwiftData
import SwiftUI

struct LogEntryView: View {
    // Allows us to dismiss the modal
    @Environment(\.dismiss) private var dismiss
    // Gives us access to the SwiftData database
    @Environment(\.modelContext) private var modelContext

    // Form State
    @State private var selectedCategory: String = IntakeEntry.Category.water
    @State private var beverageName: String = "Water"
    @State private var amountOz: Double = 8.0
    @State private var caffeineContentMg: Double = 0.0

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Category Picker
                Section(header: Text("Beverage Type")) {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Water").tag(IntakeEntry.Category.water)
                        Text("Caffeine").tag(IntakeEntry.Category.caffeine)
                    }
                    .pickerStyle(.segmented)
                    // Auto-update defaults when swapping categories for better UX
                    .onChange(of: selectedCategory) { oldVal, newVal in
                        if newVal == IntakeEntry.Category.water {
                            beverageName = "Water"
                            caffeineContentMg = 0.0
                        } else {
                            beverageName = "Coffee"
                            caffeineContentMg = 95.0  // Avg coffee caffeine
                        }
                    }
                }

                // MARK: - Basic Details
                Section(header: Text("Details")) {
                    TextField("Beverage Name", text: $beverageName)

                    Stepper(value: $amountOz, in: 1...128, step: 1) {
                        HStack {
                            Text("Amount")
                            Spacer()
                            Text("\(amountOz, specifier: "%.0f") oz")
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // MARK: - Caffeine Content (Conditional)
                if selectedCategory == IntakeEntry.Category.caffeine {
                    Section(
                        header: Text("Caffeine Content"),
                        footer: Text(
                            "Adjust the estimated caffeine in milligrams."
                        )
                    ) {
                        Stepper(value: $caffeineContentMg, in: 0...600, step: 5)
                        {
                            HStack {
                                Text("Caffeine")
                                Spacer()
                                Text(
                                    "\(caffeineContentMg, specifier: "%.0f") mg"
                                )
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Log Drink")
            .navigationBarTitleDisplayMode(.inline)

            // MARK: - Toolbar Buttons
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(beverageName.isEmpty)  // Prevent saving without a name
                }
            }
        }
    }

    // MARK: - Save Logic
    private func saveEntry() {
        let newEntry = IntakeEntry(
            category: selectedCategory,
            beverageName: beverageName,
            amountOz: amountOz,
            caffeineContentMg: selectedCategory == IntakeEntry.Category.water
                ? 0.0 : caffeineContentMg,
            timestamp: Date()
        )

        // Insert into database
        modelContext.insert(newEntry)

        // Dismiss the modal
        dismiss()
    }
}

#Preview {
    LogEntryView()
        .modelContainer(for: IntakeEntry.self, inMemory: true)
}
