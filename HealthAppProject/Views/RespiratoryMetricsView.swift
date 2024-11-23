//
//  RespiratorySnapShotView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/21/24.
//

import SwiftUI

struct RespiratoryMetricsView: View {
 
    let gradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .lightestBlue,
                .lightBlue,
                .mediumBlue,
                .deepBlue,
                .darkBlue
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        HealthMetricSnapShotView(title: "Respiratory Overview", textGradient: gradient, borderColor: .blue) {
            VStack(alignment: .leading, spacing: 12) {
                HealthMetricInfoView(imageText: "lungs.fill", metricTitle: "Respiratory Rate", metricValue: 16, unit: "br/min")
                HealthMetricInfoView(imageText: "drop.circle", metricTitle: "Blood Oxygen", metricValue: 98, unit: "%")
                HealthMetricInfoView(imageText: "figure.run.circle", metricTitle: "VO2max", metricValue: 48.7, unit: "ml/kg/min")
            }
        }   
    }
}

#Preview {
    RespiratoryMetricsView()
}
