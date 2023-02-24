//
//  StepCountGaugeView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/26/23.
//

import SwiftUI

struct ProgressGaugeView: View {
    
    var progress: Double
    var minValue: Double
    var maxValue: Double
    var scaleValue: Double
    var gaugeColor: Color
    var title: String
    
    
    var body: some View {
        Gauge(value: progress, in: minValue...maxValue) {
            Text(title)
                .foregroundColor(.primary)
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(gaugeColor)
        .scaleEffect(scaleValue)
    }
}

struct ProgressGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressGaugeView(progress: 2500, minValue: 0, maxValue: 10_000, scaleValue: 0.8, gaugeColor: .blue, title: "25%")
    }
}
