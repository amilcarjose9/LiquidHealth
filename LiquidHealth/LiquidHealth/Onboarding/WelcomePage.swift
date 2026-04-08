import SwiftUI

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

