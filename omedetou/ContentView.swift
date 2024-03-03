//
//  ContentView.swift
//  omedetou
//
//  Created by Patryk Puciłowski on 01/03/2024.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var currentAffirmation: String = affirmations.randomElement()!.content

    var body: some View {
        VStack {
            NavigationStack {
                Image(systemName: "hands.and.sparkles.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                Image(.omedetou)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Spacer()

                Text(currentAffirmation)

                Spacer()

                Button("Ask daddy for permission") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("we good")
                        } else if let error {
                            print(error.localizedDescription)
                        }
                    }
                }

                Button(action: {
                    currentAffirmation = affirmations.randomElement()!.content

                    let notification = UNMutableNotificationContent()
                    notification.title = "Here's your affirmation"
                    notification.subtitle = currentAffirmation
                    notification.sound = .default

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  1    , repeats: false)

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)

                    UNUserNotificationCenter.current().add(request)
                    
                }, label: {
                    Text("Change affirmation")
                }).buttonStyle(.borderedProminent)

                Spacer()
            }
        }.padding()
        // https://youtu.be/hf1DkBQRQj4?si=ygJiuU3FAbYGv76o omedetou
    }
}

#Preview {
    ContentView()
}
