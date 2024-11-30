//
//  MetricRowView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/28/24.
//

import SwiftUI

struct MetricRowView: View {
    
    var imageName: String
    var title: String
    var healthValue: Double
    var unit: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: imageName)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.heavy)
            }
            HStack(alignment: .firstTextBaseline ,spacing: 2) {
                Text("\(healthValue, format: .number.precision(.fractionLength(0)))")
                    .font(.title.weight(.semibold))
                Text(unit)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    MetricRowView(imageName: "heart.circle", title: "Heart Rate", healthValue: 69, unit: "bpm")
}
