//
//  HealthMetricValue.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 5/14/24.
//

import Foundation

struct HealthMetricValue: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
