//
//  MockData.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 1/11/25.
//

import Foundation

struct MockData {
    
    static var heartRate: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<7 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? Date(), value: .random(in: 55...200))
            array.append(metric)
        }
        
        return array
    }
    
    static var exerciseTime: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<7 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? Date(), value: .random(in: 1...90))
            array.append(metric)
        }
        
        return array
    }

}
