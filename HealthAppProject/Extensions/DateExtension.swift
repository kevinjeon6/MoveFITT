//
//  DateExtension.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/29/22.
//

import Foundation

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
    }
}
