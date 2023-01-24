//
//  ExerciseGaugeView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/23/23.
//

import SwiftUI

struct ExerciseGaugeView: View {
    var progress: Double
    var minValue: Double
    var maxValue: Double
    var title: String
    
    let gradient = Gradient(colors: [.red, .orange, .yellow, .mint, .green])
    
    var body: some View {
        VStack(spacing: 10) {
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
            .tint(gradient)
            .scaleEffect(1.5)
        
            
            Text(title)
        }//VStack
    }
}

struct ExerciseGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGaugeView(progress: 75, minValue: 0, maxValue: 150, title: "Weekly Goal")
    }
}
