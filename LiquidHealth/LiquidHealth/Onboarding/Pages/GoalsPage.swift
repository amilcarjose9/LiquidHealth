import SwiftData
import SwiftUI

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

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
        .modelContainer(for: [UserSettings.self, IntakeEntry.self], inMemory: true)
}

