//
//  BeverageTemplatesView.swift
//  LiquidHealth
//
//  Created by Ivan Gabriel Salazar Medina on 4/8/26.
//

import SwiftUI
import SwiftData

struct BeverageTemplatesView: View {
    // Access the SwiftData context and fetch saved templates
    @Environment(\.modelContext) private var modelContext
    @Query private var templates: [BeverageTemplate]

    // Form State
    @State private var selectedCategory: String = IntakeEntry.Category.water
    @State private var newName: String = ""
    @State private var newAmount: String = ""
    @State private var newCaffeine: String = ""

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Create Template Section
                Section(header: Text("Create New Template")) {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Water").tag(IntakeEntry.Category.water)
                        Text("Caffeine").tag(IntakeEntry.Category.caffeine)
                    }
                    .pickerStyle(.segmented)

                    TextField("Template Name (e.g., Gym Flask)", text: $newName)

                    TextField("Amount (oz)", text: $newAmount)
                        .keyboardType(.decimalPad)

                    if selectedCategory == IntakeEntry.Category.caffeine {
                        TextField("Caffeine Content (mg)", text: $newCaffeine)
                            .keyboardType(.decimalPad)
                    }

                    Button(action: addTemplate) {
                        Text("Save Template")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.blue)
                    }
                    .disabled(newName.isEmpty || newAmount.isEmpty)
                }

                // MARK: - Manage Existing Templates Section
                Section(
                    header: Text("Saved Templates"),
                    footer: Text("Swipe left to delete a template.")
                ) {
                    if templates.isEmpty {
                        Text("No templates saved yet.")
                            .foregroundColor(.secondary)
                    } else {
                        List {
                            ForEach(templates) { template in
                                HStack {
                                    // Visual Icon based on category
                                    Image(
                                        systemName: template.category
                                            == IntakeEntry.Category.water
                                            ? "drop.fill"
                                            : "cup.and.saucer.fill"
                                    )
                                    .foregroundColor(
                                        template.category
                                            == IntakeEntry.Category.water
                                            ? .blue : .brown
                                    )
                                    .frame(width: 30)

                                    VStack(alignment: .leading) {
                                        Text(template.name)
                                            .font(.headline)
                                        Text(
                                            "\(template.amountOz, specifier: "%.0f") oz"
                                        )
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    // Show caffeine amount if applicable
                                    if template.category
                                        == IntakeEntry.Category.caffeine
                                    {
                                        Text(
                                            "\(template.caffeineMg, specifier: "%.0f") mg"
                                        )
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.brown)
                                    }
                                }
                            }
                            .onDelete(perform: deleteTemplate)
                        }
                    }
                }
            }
            .navigationTitle("Manage Templates")
        }
    }

    // MARK: - Logic Methods

    private func addTemplate() {
        // Convert strings to doubles
        guard let amount = Double(newAmount) else { return }
        let caffeine = Double(newCaffeine) ?? 0.0

        let newTemplate = BeverageTemplate(
            category: selectedCategory,
            name: newName,
            amountOz: amount,
            caffeineMg: selectedCategory == IntakeEntry.Category.water
                ? 0.0 : caffeine
        )

        // Save to SwiftData
        modelContext.insert(newTemplate)

        // Reset form fields
        newName = ""
        newAmount = ""
        newCaffeine = ""

        // Hide keyboard after saving
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    private func deleteTemplate(offsets: IndexSet) {
        for index in offsets {
            let templateToDelete = templates[index]
            modelContext.delete(templateToDelete)
        }
    }
}

// MARK: - Preview
#Preview {
    BeverageTemplatesView()
        .modelContainer(
            for: [IntakeEntry.self, BeverageTemplate.self],
            inMemory: true
        )
}
