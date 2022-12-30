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
}
