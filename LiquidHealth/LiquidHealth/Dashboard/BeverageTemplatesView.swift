//
//  BeverageTemplatesView.swift
//  LiquidHealth
//
//  Created by Ivan Gabriel Salazar Medina on 4/8/26.
//

import SwiftUI
import SwiftData

@Model
class BeverageTemplateModel {
    var name: String
    var amount: Double

    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
}

// Model for each beverage template
struct BeverageTemplate: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
}

// Main UI
struct BeverageTemplatesView: View {
    @State private var templates: [BeverageTemplate] = [
        BeverageTemplate(name: "Water", amount: 8),
        BeverageTemplate(name: "Coffee", amount: 8),
        BeverageTemplate(name: "Juice", amount: 10)
    ]
    @State private var newName: String = ""
    @State private var newAmount: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Quick Add")
                .font(.headline)
                .padding(.horizontal)
            
            HStack {
                TextField("Name", text: $newName)
                    .textFieldStyle(.roundedBorder)

                TextField("Oz", text: $newAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Button("Add Template") {
                if let amount = Double(newAmount), !newName.isEmpty {
                    let newTemplate = BeverageTemplate(name: newName, amount: amount)
                    templates.append(newTemplate)
                    newName = ""
                    newAmount = ""
                }
            }
            .padding(.horizontal)
            
            // Horizontal scroll like modern apps
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    
                    ForEach(Array(templates.enumerated()), id: \.element.id) { index, drink in
                        Button {
                            print("Added \(drink.name)")
                        } label: {
                            VStack {
                                Text(drink.name)
                                    .font(.subheadline)
                                    .bold()
                                
                                Text("\(Int(drink.amount)) oz")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                if index >= 3 {
                                    Button("Delete") {
                                        templates.remove(at: index)
                                    }
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .frame(width: 100)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Preview
#Preview {
    BeverageTemplatesView()
}
