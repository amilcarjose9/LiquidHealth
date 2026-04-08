import SwiftUI
import UserNotifications

struct NotificationsPage: View {
    var body: some View {
        VStack(spacing: 28) {
            Image(systemName: "text.pad.header.badge.clock")
                .font(.system(size: 100))
                .foregroundColor(.white)
                .shadow(radius: 10)
                .padding(.top, 80)

            Text("Enable notifications to optimize your hydration and caffeine intake.")
                .font(
                    .title
                        .bold()
                )
                .foregroundColor(.white)

            Button("Enable Notifications") {
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound]
                ) {
                    success,
                    error in
                    if success {
                        let content = UNMutableNotificationContent()
                        content.title = "Hydrate!🚰"
                        content.subtitle = "Or caffeinate ☕️."
                        content.sound = UNNotificationSound.default
                        
                        // show this notification five seconds from now
                        let trigger = UNTimeIntervalNotificationTrigger(
                            timeInterval: 4 * 60 * 60,
                            repeats: true
                        )

                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: "hydration-reminder", content: content, trigger: trigger)

                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(25)

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
