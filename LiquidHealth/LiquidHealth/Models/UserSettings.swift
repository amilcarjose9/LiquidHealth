//
//  UserSettings.swift
//  LiquidHealth
//
//  Created by henry cruz on 4/6/26.
//

import Foundation
import SwiftData
@Model
final class UserSettings {
    var id: UUID
    var waterGoalOz: Double
    var caffeineLimitMg: Double
    var wakeUpTime: Date
    var bedTime: Date
    var notificationsEnabled: Bool
    
    init(
        id: UUID = UUID(),
        waterGoalOz: Double = 64.0,
        caffeineLimitMg: Double = 400.0,
        wakeUpTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date(),
        bedTime: Date = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date(),
        notificationsEnabled: Bool = true
    ) {
        self.id = id
        self.waterGoalOz = waterGoalOz
        self.caffeineLimitMg = caffeineLimitMg
        self.wakeUpTime = wakeUpTime
        self.bedTime = bedTime
        self.notificationsEnabled = notificationsEnabled
    }
}
// MARK: - Convenience Methods
extension UserSettings {
    /// Returns the user's wake-up hour (0-23)
    var wakeUpHour: Int {
        Calendar.current.component(.hour, from: wakeUpTime)
    }
    
    /// Returns the user's bedtime hour (0-23)
    var bedTimeHour: Int {
        Calendar.current.component(.hour, from: bedTime)
    }
    
    /// Calculates how many hours before bedtime caffeine should be cut off (based on 5-hour half-life)
    var caffeineCutoffHoursBeforeBed: Int {
        return 6 // Conservative estimate: stop caffeine 6 hours before bed
    }
    
    /// Returns the time of day when user should stop consuming caffeine
    var caffeineCutoffTime: Date {
        Calendar.current.date(byAdding: .hour, value: -caffeineCutoffHoursBeforeBed, to: bedTime) ?? bedTime
    }
}
