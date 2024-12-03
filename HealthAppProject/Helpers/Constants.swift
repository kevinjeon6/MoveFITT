//
//  Constants.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/29/23.
//

import Foundation
struct Constants {
    static var stepGoal = "step goal"
    static var exerciseDailyGoal = "exercise daily goal"
    static var exerciseWeeklyGoal = "exercise weekly goal"
    static var muscleStrengtheningWeeklyGoal = "muscle strengthening weekly goal"
    static var notifications = "notifications"
    

    static var todayDateString = Date().formatted(.dateTime.weekday(.wide).month(.wide).day())
    static var strengthActivityWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
    //Start of the week is Sunday - Saturday
    
    
    static var currentWeekDatesString: String {
//        let date = Date()
        let calendar = Calendar.current
        
//        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start
        //End week is Adding 6 days from the start of a new week. Example. Jan 29 is the 5th week of the year and is the start of a new week
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: Constants.strengthActivityWeek)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let startOfWeekString = dateFormatter.string(from: Constants.strengthActivityWeek)
        let endOfWeekString = dateFormatter.string(from: endOfWeek!)
    
        
        return "\(startOfWeekString) - \(endOfWeekString)"
    }
    
    
    static var past7DaysRange: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let startDate = calendar.date(byAdding: .day, value: -6, to: today)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let startOfWeekString = dateFormatter.string(from: startDate)
        let endOfWeekString = dateFormatter.string(from: today)
    
        
        return "\(startOfWeekString) - \(endOfWeekString)"
        
    }
    
}
