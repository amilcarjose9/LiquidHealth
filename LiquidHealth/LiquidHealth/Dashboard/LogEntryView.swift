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

    // Fetch saved templates
    @Query private var templates: [BeverageTemplate]

    // Form State
    @State private var selectedCategory: String = IntakeEntry.Category.water
    @State private var beverageName: String = "Water"
    @State private var amountOz: Double = 8.0
    @State private var caffeineContentMg: Double = 0.0

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Quick Select Templates
                if !templates.isEmpty {
                    Section(header: Text("Quick Select")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(templates) { template in
                                    Button(action: {
                                        applyTemplate(template)
                                    }) {
                                        VStack(alignment: .leading) {
                                            Text(template.name)
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(.primary)

                                            Text(
                                                "\(template.amountOz, specifier: "%.0f") oz"
                                            )
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        }
                                        .padding()
                                        // Color code based on category
                                        .background(
                                            template.category
                                                == IntakeEntry.Category.water
                                                ? Color.blue.opacity(0.15)
                                                : Color.brown.opacity(0.15)
                                        )
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                        }
                        .listRowInsets(EdgeInsets())  // Makes the scroll view go edge-to-edge in the form
                    }
                }

                // MARK: - Category Picker
                Section(header: Text("Beverage Type")) {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Water").tag(IntakeEntry.Category.water)
                        Text("Caffeine").tag(IntakeEntry.Category.caffeine)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedCategory) { oldVal, newVal in
                        // Only auto-update if the user hasn't typed a custom name yet
                        if beverageName == "Water" || beverageName == "Coffee" {
                            if newVal == IntakeEntry.Category.water {
                                beverageName = "Water"
                                caffeineContentMg = 0.0
                            } else {
                                beverageName = "Coffee"
                                caffeineContentMg = 95.0
                            }
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

                // MARK: - Save as Template
                Section {
                    Button(action: saveAsTemplate) {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Save as Quick Add Template")
                        }
                    }
                    .disabled(beverageName.isEmpty)
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

    // MARK: - Logic Methods

    /// Auto-fills the form with data from the tapped template
    private func applyTemplate(_ template: BeverageTemplate) {
        selectedCategory = template.category
        beverageName = template.name
        amountOz = template.amountOz
        caffeineContentMg = template.caffeineMg
    }

    /// Saves the current form state as a reusable template
    private func saveAsTemplate() {
        let newTemplate = BeverageTemplate(
            category: selectedCategory,
            name: beverageName,
            amountOz: amountOz,
            caffeineMg: selectedCategory == IntakeEntry.Category.water
                ? 0.0 : caffeineContentMg
        )
        modelContext.insert(newTemplate)
    }

    /// Logs the actual drink to the user's daily intake
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
        .modelContainer(
            for: [IntakeEntry.self, BeverageTemplate.self],
            inMemory: true
        )
}
