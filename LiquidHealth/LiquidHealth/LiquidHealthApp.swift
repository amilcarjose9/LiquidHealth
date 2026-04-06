//
//  LiquidHealthApp.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/5/26.
//
import SwiftUI
import SwiftData

@main
struct LiquidHealthApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [UserSettings.self, IntakeEntry.self]) { result in
            switch result {
            case .success(let container):
                // Preload default user settings if none exist
                preloadDefaultSettingsIfNeeded(in: container)
            case .failure(let error):
                print("Failed to initialize ModelContainer: \(error.localizedDescription)")
            }
        }
    }
    
    /// Preloads default UserSettings if the database is empty (first launch)
    private func preloadDefaultSettingsIfNeeded(in container: ModelContainer) {
        let context = container.mainContext
        
        // Check if any UserSettings exist
        let fetchDescriptor = FetchDescriptor<UserSettings>()
        
        do {
            let existingSettings = try context.fetch(fetchDescriptor)
            
            // If no settings exist, create default settings
            if existingSettings.isEmpty {
                let defaultSettings = UserSettings(
                    waterGoalOz: 64.0,           // 8 cups (8oz each)
                    caffeineLimitMg: 400.0,      // FDA recommended max
                    wakeUpTime: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date(),
                    bedTime: Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date(),
                    notificationsEnabled: true
                )
                
                context.insert(defaultSettings)
                
                try context.save()
                print("✅ Default UserSettings created successfully")
            } else {
                print("ℹ️ UserSettings already exist, skipping preload")
            }
        } catch {
            print("❌ Error preloading default settings: \(error.localizedDescription)")
        }
    }
}
