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
    @State private var currentAffirmation: String = affirmations.randomElement()!.content
    @State private var isAlertShown = false
    var body: some View {
        VStack {
            NavigationStack {
                Image(systemName: "hands.and.sparkles.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                Image(.omedetou)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Button(action: {
                    currentAffirmation = affirmations.randomElement()!.content
                    checkIfNotifsOn()
                }, label: {
                    Text("Notify about affirmation everyday at 7AM")
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
            }
        }.padding()
        // https://youtu.be/hf1DkBQRQj4?si=ygJiuU3FAbYGv76o omedetou
    }

    func checkIfNotifsOn() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        os_log("User accepted notifications")
                    } else if let error {
                        os_log("Something went wrong \(error.localizedDescription)")
                    }
                }
            case .denied:
                isAlertShown.toggle()
                os_log("Bro has notifs off")
            case .authorized:
                os_log("Notifications are ON")
                notifyUser(affirmation: currentAffirmation)

            case .provisional:
                os_log("Notifications are kinda ON")
                notifyUser(affirmation: currentAffirmation)

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
