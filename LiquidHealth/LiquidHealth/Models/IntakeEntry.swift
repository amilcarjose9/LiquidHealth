//
//  IntakeEntry.swift
//  LiquidHealth
//
//  Created by henry cruz on 4/6/26.
//
import Foundation
import SwiftData
@Model
final class IntakeEntry {
    var id: UUID
    var category: String
    var beverageName: String
    var amountOz: Double
    var caffeineContentMg: Double
    var timestamp: Date
    
    init(
        id: UUID = UUID(),
        category: String,
        beverageName: String,
        amountOz: Double,
        caffeineContentMg: Double = 0.0,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.category = category
        self.beverageName = beverageName
        self.amountOz = amountOz
        self.caffeineContentMg = caffeineContentMg
        self.timestamp = timestamp
    }
}
// MARK: - Category Constants
extension IntakeEntry {
    enum Category {
        static let water = "Water"
        static let caffeine = "Caffeine"
    }
    
    /// Returns true if this entry is a water-based beverage
    var isWater: Bool {
        return category == Category.water
    }
    
    /// Returns true if this entry contains caffeine
    var isCaffeine: Bool {
        return category == Category.caffeine || caffeineContentMg > 0
    }
    
    /// Formatted timestamp for display (e.g., "2:45 PM")
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    /// Returns the date component (ignoring time) for grouping entries by day
    var dateOnly: Date {
        Calendar.current.startOfDay(for: timestamp)
    }
}
// MARK: - Common Beverage Presets
extension IntakeEntry {
    /// Creates a standard water entry (8 oz)
    static func createWaterEntry(amountOz: Double = 8.0) -> IntakeEntry {
        return IntakeEntry(
            category: Category.water,
            beverageName: "Water",
            amountOz: amountOz,
            caffeineContentMg: 0.0
        )
    }
    
    /// Creates a standard coffee entry (8 oz, ~95mg caffeine)
    static func createCoffeeEntry(amountOz: Double = 8.0) -> IntakeEntry {
        let caffeinePerOz = 95.0 / 8.0 // Standard coffee has ~95mg per 8oz
        return IntakeEntry(
            category: Category.caffeine,
            beverageName: "Coffee",
            amountOz: amountOz,
            caffeineContentMg: caffeinePerOz * amountOz
        )
    }
    
    /// Creates an energy drink entry (8 oz, ~80mg caffeine)
    static func createEnergyDrinkEntry(amountOz: Double = 8.0) -> IntakeEntry {
        let caffeinePerOz = 80.0 / 8.0
        return IntakeEntry(
            category: Category.caffeine,
            beverageName: "Energy Drink",
            amountOz: amountOz,
            caffeineContentMg: caffeinePerOz * amountOz
        )
    }
}
