//
//  HeartMetricsView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/22/24.
//

import SwiftUI

struct HeartMetricsView: View {
    
    let gradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .lightestRed,
                .lightRed,
                .mediumRed,
                .deepRed,
                .darkRed
        ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        HealthMetricSnapShotView(title: "Heart Overview", textGradient: gradient, borderColor: .red) {
                    VStack(alignment: .leading, spacing: 12) {
                        HealthMetricInfoView(imageText: "arrow.down.heart.fill", metricTitle: "Resting Heart Rate", metricValue: 64, unit: "bpm")
            
                        HealthMetricInfoView(imageText: "heart.circle", metricTitle: "Heart Rate", metricValue: 74, unit: "bpm")
                        HealthMetricInfoView(imageText: "waveform.path.ecg.rectangle.fill", metricTitle: "Heart Rate Variability (HRV)", metricValue: 220, unit: "ms")
                    }
                }
        }
}

#Preview {
    HeartMetricsView()
}
