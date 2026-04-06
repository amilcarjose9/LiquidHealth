//
//  ProgressRingView.swift
//  LiquidHealth
//
//  Created by Amilcar Pena Jr on 4/6/26.
//

import SwiftUI

struct ProgressRingView: View {
    var progress: Double
    var color: Color
    var icon: String
    var label: String
    var value: String

    var body: some View {
        VStack {
            ZStack {
                // Background Track
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 14)

                // Foreground Progress
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    // Rotate so the progress starts at the 12 o'clock position
                    .rotationEffect(.degrees(-90))

                // Center Icon
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
            }
            .frame(width: 110, height: 110)

            // Text Labels
            Text(label)
                .font(.headline)
                .padding(.top, 8)

            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProgressRingView(
        progress: 0.62,
        color: .blue,
        icon: "drop.fill",
        label: "Water",
        value: "40 / 64 oz"
    )
}
