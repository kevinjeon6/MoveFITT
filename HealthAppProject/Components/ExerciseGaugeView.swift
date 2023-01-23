//
//  ExerciseGaugeView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/23/23.
//

import SwiftUI

struct ExerciseGaugeView: View {
    var progress = 80.0
    private let minValue = 0.0
    private let maxValue = 150.0
    
    var body: some View {
        VStack(spacing: 20) {
            Gauge(value: progress, in: minValue...maxValue) {
                //
            } currentValueLabel: {
                Text(progress, format: .number)
            } minimumValueLabel: {
                Text(minValue, format: .number)
            } maximumValueLabel: {
                Text(maxValue, format: .number)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(.blue)
            .scaleEffect(1.5)
            .padding(.bottom)
            
            Text("Weekly Goal")
        }
    }
}

struct ExerciseGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGaugeView()
    }
}
