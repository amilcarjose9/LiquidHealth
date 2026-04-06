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
    @State private var isOnboardingComplete: Bool = false
    @State private var isCheckingFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isCheckingFirstLaunch {
                    // Show loading screen while checking first launch status
                    LoadingView()
                } else if !isOnboardingComplete {
                    // Show onboarding for first-time users
                    OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                } else {
                    // Show main app
                    ContentView()
                }
            }
        }
        .modelContainer(for: [UserSettings.self, IntakeEntry.self]) { result in
            switch result {
            case .success(let container):
                // Check if this is first launch
                checkFirstLaunchStatus(in: container)
            case .failure(let error):
                print("Failed to initialize ModelContainer: \(error.localizedDescription)")
                isCheckingFirstLaunch = false
            }
        }
    }
    
    /// Checks if UserSettings exist to determine first launch status
    private func checkFirstLaunchStatus(in container: ModelContainer) {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<UserSettings>()
        
        do {
            let existingSettings = try context.fetch(fetchDescriptor)
            
            // If settings exist, skip onboarding
            if !existingSettings.isEmpty {
                print("ℹ️ UserSettings found - skipping onboarding")
                isOnboardingComplete = true
            } else {
                print("ℹ️ First launch detected - showing onboarding")
                isOnboardingComplete = false
            }
            
            isCheckingFirstLaunch = false
        } catch {
            print("❌ Error checking first launch status: \(error.localizedDescription)")
            isOnboardingComplete = false
            isCheckingFirstLaunch = false
        }
    }
}
// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
    }
}
