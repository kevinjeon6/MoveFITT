//
//  HealthMetricInfoView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/21/24.
//

import SwiftUI

struct HealthMetricInfoView: View {
    
    var imageText: String
    var metricTitle: String
    var metricValue: Double
    var unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: imageText)
                Text(metricTitle)
                    .font(.subheadline)
                    .fontWeight(.heavy)
            }
            Text("\(metricValue, format: .number.precision(.fractionLength(0))) \(unit)")
        }
        .font(.title2)
    }
}
