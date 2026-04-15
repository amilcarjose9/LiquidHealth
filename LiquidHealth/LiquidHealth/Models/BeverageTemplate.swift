//
//  BeverageTemplate.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/15/26.
//
import Foundation
import SwiftData

@Model
final class BeverageTemplate {
    var id: UUID
    var category: String
    var name: String
    var amountOz: Double
    var caffeineMg: Double
    
    init(
        id: UUID = UUID(),
        category: String,
        name: String,
        amountOz: Double,
        caffeineMg: Double = 0.0
    ) {
        self.id = id
        self.category = category
        self.name = name
        self.amountOz = amountOz
        self.caffeineMg = caffeineMg
    }
}
