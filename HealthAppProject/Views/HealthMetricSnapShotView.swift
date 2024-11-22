//
//  HealthMetricSnapShotView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/11/24.
//

import SwiftUI

struct HealthMetricSnapShotView: View {
    
    var title: String
    var textGradient: LinearGradient
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    //Go to charts of the HealthMetric
                } label: {
                    HStack {
                        Text(title)
                            .font(.title3.weight(.semibold))
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.bottom, 4)
                }
                .foregroundStyle(textGradient)
                
                Divider()
                    .frame(height: 1)
                    .overlay(.white)
                
                Grid(alignment: .leading, horizontalSpacing: 80, verticalSpacing: 20) {
                    GridRow {
                        HealthMetricInfoView(imageText: "arrow.down.heart.fill", metricTitle: "RHR", metricValue: 64, unit: "bpm")
                        
                        HealthMetricInfoView(imageText: "heart.circle", metricTitle: "HR", metricValue: 74, unit: "bpm")
                        
                    }
                    
                    GridRow {
                        HealthMetricInfoView(imageText: "waveform.path.ecg.rectangle.fill", metricTitle: "HRV", metricValue: 220, unit: "ms")
                        
                        HealthMetricInfoView(imageText: "heart.circle.fill", metricTitle: "Walking HR", metricValue: 78, unit: "bpm")
                    }
                }
                .padding(.top, 20)
            }
            .padding(20)
            .foregroundStyle(textGradient)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
            )
        }
    }
}

#Preview {
    
    let previewGradient = LinearGradient(
        gradient: Gradient(
            colors: [.lightestRed,.lightRed,.mediumRed,.deepRed,.darkRed]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    HealthMetricSnapShotView(title: "Heart Overview", textGradient: previewGradient)
}
