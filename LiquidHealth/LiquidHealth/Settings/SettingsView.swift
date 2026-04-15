//
//  SettingsView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//

import SwiftUI

// Settings screen that allows the user to configure goals and profile information
struct SettingsView: View {
    // Uses shared settings from the environment when available, otherwise falls back to a local guest/default settings object
    @Environment(UserSettings.self) private var environmentSettings: UserSettings?
    @State private var guestSettings = UserSettings()

    // Main UI layout for the settings screen
    var body: some View {
        let activeSettings = environmentSettings ?? guestSettings
        @Bindable var settings = activeSettings
        // Navigation container for the Settings screen
        NavigationStack {
            // Form layout to organize settings into sections
            Form {
                // Section for adjusting daily intake goals
                Section("Daily Goals") {
                    // Stepper to adjust daily water goal in ounces
                    Stepper(value: $settings.waterGoalOz, in: 0...300, step: 5) {
                        HStack {
                            Text("Water Goal")
                            Spacer()
                            Text("\(Int(settings.waterGoalOz)) oz")
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Stepper to adjust daily caffeine limit in milligrams
                    Stepper(value: $settings.caffeineLimitMg, in: 0...500, step: 10) {
                        HStack {
                            Text("Caffeine Limit")
                            Spacer()
                            Text("\(Int(settings.caffeineLimitMg)) mg")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Section for daily routine preferences
                Section("Routine") {
                    // Time picker for the user's wake-up time
                    DatePicker("Wake Up Time", selection: $settings.wakeUpTime, displayedComponents: .hourAndMinute)

                    // Time picker for the user's bedtime
                    DatePicker("Bed Time", selection: $settings.bedTime, displayedComponents: .hourAndMinute)

                    // Toggle for enabling or disabling reminders
                    Toggle("Notifications", isOn: $settings.notificationsEnabled)
                }
                
                // MARK: - App Preferences
                // Section for custom quick-add templates and other app settings
                Section("Preferences") {
                    NavigationLink(destination: BeverageTemplatesView()) {
                        HStack {
                            Image(systemName: "star.square.on.square.fill")
                                .foregroundColor(.blue)
                            Text("Manage Quick Add Templates")
                        }
                    }
                }
            }
            // Title displayed in the navigation bar
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environment(UserSettings())
}
