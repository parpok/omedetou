//
//  ContentView.swift
//  omedetou
//
//  Created by Patryk Puciłowski on 01/03/2024.
//

import OSLog
import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var currentAffirmation: String?
    @State private var isAlertShown = false
    @State private var notificationTime = Date.now

    private var dateFormatter = DateFormatter()

    var body: some View {
        VStack {
            NavigationStack {
                Image(systemName: "hands.and.sparkles.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                Image(.omedetou)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                DatePicker("Wen notifs?", selection: $notificationTime, displayedComponents: [.hourAndMinute]).datePickerStyle(.graphical)

                Button(action: {
                    Task {
                        currentAffirmation = try await
                            getAffirmationsFromServer().randomElement()?.content
                    }
                    currentAffirmation = currentAffirmation
                    checkIfNotifsOn()
                }, label: {
                    Text("Notify about affirmation tommorow at \(notificationTime.formatted(date: .omitted, time: .shortened))")
                }).buttonStyle(.borderedProminent).alert(isPresented: $isAlertShown) {
                    Alert(
                        title: Text("Notifications are off"),
                        message: Text("omedetou requires notifications"),
                        primaryButton: .default(Text("OK")),
                        secondaryButton: .default(Text("Open Settings"), action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        })
                    )
                }
                Spacer()

//                Text(currentAffirmation ?? "IDK")
            }.navigationTitle("omedetou")
        }.padding()
        // https://youtu.be/hf1DkBQRQj4?si=ygJiuU3FAbYGv76o omedetou
    }

    func notifyUser(affirmation: String) {
        let notification = UNMutableNotificationContent()
        notification.title = "Here's your affirmation"
        notification.subtitle = affirmation
        notification.sound = .default

        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: notificationTime)

        // Ensure the date is for tomorrow
        dateComponents.day = 1 // Adding 1 day sets date to tomorrow

        // Extract hour from notificationTime
        let hour = Calendar.current.component(.hour, from: notificationTime)

        dateComponents.hour = hour

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        do {
            notificationCenter.add(request)
            os_log("Notify about affirmation tommorow at \(notificationTime.formatted(date: .omitted, time: .shortened))")
        }
    }

    func checkIfNotifsOn() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        os_log("User accepted notifications")
                        notifyUser(affirmation: currentAffirmation ?? "Shit fucked up")
                    } else if let error {
                        os_log("Something went wrong \(error.localizedDescription)")
                    }
                }
            case .denied:
                isAlertShown.toggle()
                os_log("Bro has notifs off")
            case .authorized:
                os_log("Notifications are ON")
                notifyUser(affirmation: currentAffirmation ?? "Shit fucked up")

            case .provisional:
                os_log("Notifications are kinda ON")
                notifyUser(affirmation: currentAffirmation ?? "Shit fucked up")

            case .ephemeral:
                os_log("Wait is that an app clip")

            default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}
