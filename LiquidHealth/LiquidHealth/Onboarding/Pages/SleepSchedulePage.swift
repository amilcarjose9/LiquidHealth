import SwiftUI

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
