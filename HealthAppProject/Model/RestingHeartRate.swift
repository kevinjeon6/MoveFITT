//
//  RestingHeartRate.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/9/23.
//

import Foundation


struct RestingHeartRate: Identifiable {
    let id = UUID()
    let restingValue: Int
    let date: Date
}
