//
//  HealthMetric.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 5/14/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    var minValue: Double?
    var maxValue: Double?
    var mostRecentValue: Double?
}
