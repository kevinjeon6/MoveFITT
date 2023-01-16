//
//  Step.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/29/22.
//

import Foundation



struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
    
    
    static let stepExample: [Step] = [
        .init(count: 7234, date: Date.from(year: 2022, month: 11, day: 1)),
        .init(count: 6243, date: Date.from(year: 2022, month: 11, day: 2)),
        .init(count: 2345, date: Date.from(year: 2022, month: 11, day: 3)),
        .init(count: 12096, date: Date.from(year: 2022, month: 11, day: 4)),
        .init(count: 10561, date: Date.from(year: 2022, month: 11, day: 5)),
        .init(count: 11790, date: Date.from(year: 2022, month: 11, day: 6)),
        .init(count: 9973, date: Date.from(year: 2022, month: 11, day: 7))
    ]
}
