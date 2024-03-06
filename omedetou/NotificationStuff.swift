//
//  NotificationStuff.swift
//  omedetou
//
//  Created by Patryk Puciłowski on 04/03/2024.
//

import Foundation
import UserNotifications
import OSLog

func notifyUser(affirmation: String) {
    let notification = UNMutableNotificationContent()
    notification.title = "Here's your affirmation"
    notification.subtitle = affirmation
    notification.sound = .default
    
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    
    dateComponents.hour = 7

    let trigger = UNCalendarNotificationTrigger(
             dateMatching: dateComponents, repeats: true)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)

    let notificationCenter = UNUserNotificationCenter.current()
    do {
        notificationCenter.add(request)
        os_log("notifying user every day at 7AM")
    } catch {
        os_log("Something went wrong with notifying")
    }
}
