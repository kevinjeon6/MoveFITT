//
//  StepCountGaugeView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/26/23.
//

import SwiftUI

struct StepCountGaugeView: View {
    
    var progress: Double
    var minValue: Double
    var maxValue: Double
    var title: String
    
    
    var body: some View {
        Gauge(value: progress, in: minValue...maxValue) {
            Text(title)
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.blue)
        .scaleEffect(0.8)
    }
}

struct StepCountGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        StepCountGaugeView(progress: 2500, minValue: 0, maxValue: 10_000, title: "25%")
    }
}
