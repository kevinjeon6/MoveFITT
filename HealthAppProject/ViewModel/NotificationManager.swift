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
    
    let viewModel = HealthStoreViewModel()
    
    @AppStorage(Constants.notifications) var isNotificationOn = false
    
    // Singleton, since instance through the entire application rather than keep creating NotificationManager
//    static let instance = NotificationManager()
    
    //Need to request permission from user for notifcation
    
    func requestUserAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                if self.isNotificationOn {
                    self.scheduleDailyNotification()
                    self.scheduleWeeklyNotification()
                }
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Here is today's physical activity summary"
        content.subtitle = "You performed \(viewModel.currentExTime) minutes today"
        content.sound = .default
 
        //Trigger. 3 types. Time, Calendar, Location
        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Here is your weekly physical activity summary"
        content.subtitle = "You performed \(viewModel.weeklyExTime) minutes this week"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 0
        dateComponents.weekday = 7
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let weeklyRequest = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(weeklyRequest)
    }
    
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
  
}
