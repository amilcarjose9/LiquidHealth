//
//  OnboardingView.swift
//  LiquidHealth
//
//  Created by henry cruz on 4/6/26.
//

import SwiftUI
import SwiftData
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
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)
                
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
                    
                    // Page 3: Sleep Schedule
                    SleepSchedulePage(
                        wakeUpTime: $wakeUpTime,
                        bedTime: $bedTime
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
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
                        Text(currentPage == 2 ? "Get Started" : "Next")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
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
// MARK: - Welcome Page
struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "drop.fill")
                .font(.system(size: 100))
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            Text("Welcome to")
                .font(.title2)
                .foregroundColor(.white.opacity(0.9))
            
            Text("LiquidHealth")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
            
            Text("Track your hydration and caffeine intake to optimize your energy and sleep")
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}
// MARK: - Goals Page
struct GoalsPage: View {
    @Binding var waterGoalInput: String
    @Binding var caffeineLimitInput: String
    @Binding var showValidationError: Bool
    @Binding var errorMessage: String
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            VStack(spacing: 15) {
                Image(systemName: "target")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("Set Your Daily Goals")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("Customize your hydration and caffeine targets")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 20)
            
            // Water Goal Input
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.white)
                    Text("Daily Water Goal")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    TextField("64", text: $waterGoalInput)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(width: 100)
                    
                    Text("oz")
                        .foregroundColor(.white)
                        .font(.title3)
                }
                
                Text("Recommended: 64 oz (8 cups)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 40)
            
            // Caffeine Limit Input
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.white)
                    Text("Daily Caffeine Limit")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    TextField("400", text: $caffeineLimitInput)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(width: 100)
                    
                    Text("mg")
                        .foregroundColor(.white)
                        .font(.title3)
                }
                
                Text("FDA Recommended Max: 400 mg")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}
// MARK: - Sleep Schedule Page
struct SleepSchedulePage: View {
    @Binding var wakeUpTime: Date
    @Binding var bedTime: Date
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            VStack(spacing: 15) {
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("Your Sleep Schedule")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("Help us optimize your caffeine timing")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 20)
            
            // Wake Up Time
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "sunrise.fill")
                        .foregroundColor(.white)
                    Text("Wake Up Time")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                DatePicker("", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            
            // Bed Time
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "bed.double.fill")
                        .foregroundColor(.white)
                    Text("Bed Time")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                DatePicker("", selection: $bedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}
#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
        .modelContainer(for: [UserSettings.self, IntakeEntry.self], inMemory: true)
}
