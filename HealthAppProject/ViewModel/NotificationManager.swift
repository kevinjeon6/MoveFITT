//
//  NotificationManager.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/29/23.
//


import Foundation
import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    
    @AppStorage(Constants.notifications) var isNotificationOn = false
    
    // Singleton, since instance through the entire application rather than keep creating NotificationManager
//    static let instance = NotificationManager()
    
    //Need to request permission from user for notifcation
    
    func requestUserAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                if self.isNotificationOn {
                    self.scheduleDailyNotification()
                }
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "This is the first notification"
        content.subtitle = "This is something new I'm learning"
        content.sound = .default
        content.badge = 1
        
        
        //Trigger. 3 types. Time, Calendar, Location
        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 30
        
        
        //Scheduling a notificaiton on a weekday. 1 = Sunday
        dateComponents.weekday = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
    }
    
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
  
}
