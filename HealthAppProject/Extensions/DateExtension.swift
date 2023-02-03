//
//  DateExtension.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/29/22.
//

import Foundation

extension Date {
    static func sundayAt12AM() -> Date {
        let calendar = Calendar(identifier: .iso8601)
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 1
        return calendar.date(from: components) ?? Date()
    }
}



//MARK: - Date extension to go with Step Count example to visualize Step Data
extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
