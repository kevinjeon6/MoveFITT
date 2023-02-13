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
    

    
    
    
    static var currentWeekDatesString: String {
        let date = Date()
        let calendar = Calendar.current
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start
        //End week is Adding 6 days from the start of a new week. Example. Jan 29 is the 5th week of the year and is the start of a new week
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let startOfWeekString = dateFormatter.string(from: startOfWeek!)
        let endOfWeekString = dateFormatter.string(from: endOfWeek!)
    
        
        return "\(startOfWeekString) - \(endOfWeekString)"
    }
    
}
