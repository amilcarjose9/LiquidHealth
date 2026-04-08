//
//  OnboardingView.swift
//  LiquidHealth
//
//  Created by henry cruz on 4/6/26.
//

import SwiftUI
import SwiftData
import UserNotifications

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isOnboardingComplete: Bool

    // User input state
    @State private var waterGoalInput: String = "64"
    @State private var caffeineLimitInput: String = "400"
    @State private var wakeUpTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var bedTime: Date = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date()

    // Validation and UI state
    @State private var showValidationError: Bool = false
    @State private var errorMessage: String = ""
    @State private var currentPage: Int = 0

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    // Page 1: Welcome
                    WelcomePage()
                        .tag(0)

                    // Page 2: Hydration & Caffeine Goals
                    GoalsPage(
                        waterGoalInput: $waterGoalInput,
                        caffeineLimitInput: $caffeineLimitInput,
                        showValidationError: $showValidationError,
                        errorMessage: $errorMessage
                    )
                    .tag(1)

                    // Page 3: Notification Permissions
                    NotificationsPage()
                        .tag(2)

                    // Page 3: Sleep Schedule
                    SleepSchedulePage(
                        wakeUpTime: $wakeUpTime,
                        bedTime: $bedTime
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)

                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                        }
                    }

                    Spacer()

                    Button(action: {
                        handleNextButtonTap()
                    }) {
                        Text(currentPage == 3 ? "Get Started" : "Next")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 32)
            }
        }
        .alert("Invalid Input", isPresented: $showValidationError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Navigation Logic
    private func handleNextButtonTap() {
        if currentPage < 2 {
            // Validate goals page before moving forward
            if currentPage == 1 {
                if validateGoalsInput() {
                    withAnimation {
                        currentPage += 1
                    }
                }
            } else {
                withAnimation {
                    currentPage += 1
                }
            }
        } else {
            // Final page - save and complete onboarding
            saveUserSettings()
        }
    }

    // MARK: - Validation
    private func validateGoalsInput() -> Bool {
        guard let waterGoal = Double(waterGoalInput), waterGoal > 0, waterGoal <= 300 else {
            errorMessage = "Please enter a valid water goal between 1 and 300 ounces."
            showValidationError = true
            return false
        }

        guard let caffeineLimit = Double(caffeineLimitInput), caffeineLimit >= 0, caffeineLimit <= 1000 else {
            errorMessage = "Please enter a valid caffeine limit between 0 and 1000 mg."
            showValidationError = true
            return false
        }

        return true
    }

    // MARK: - Save Settings
    private func saveUserSettings() {
        guard let waterGoal = Double(waterGoalInput),
              let caffeineLimit = Double(caffeineLimitInput) else {
            return
        }

        let newSettings = UserSettings(
            waterGoalOz: waterGoal,
            caffeineLimitMg: caffeineLimit,
            wakeUpTime: wakeUpTime,
            bedTime: bedTime,
            notificationsEnabled: true
        )

        modelContext.insert(newSettings)

        do {
            try modelContext.save()
            print("✅ User settings saved successfully")

            // Complete onboarding with animation
            withAnimation {
                isOnboardingComplete = true
            }
        } catch {
            print("❌ Failed to save user settings: \(error.localizedDescription)")
            errorMessage = "Failed to save settings. Please try again."
            showValidationError = true
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
        .modelContainer(for: [UserSettings.self, IntakeEntry.self], inMemory: true)
}
