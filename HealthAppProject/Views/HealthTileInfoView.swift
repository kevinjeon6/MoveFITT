//
//  HealthTileInfoViewV2.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/28/24.
//

import SwiftUI

struct HealthTileInfoView: View {
    
    var headerTitleText: String
    var textGradient: LinearGradient
    var borderColor: Color
    
    //Metric 1 properties
    var imageText1: String
    var metricTitle1: String
    var metricValue1: Double
    var unit1: String
    var decimal1: Int
    
    //Metric 2 properties
    var imageText2: String
    var metricTitle2: String
    var metricValue2: Double
    var unit2: String
    var decimal2: Int
    
    //Metric 3 properties
    var imageText3: String
    var metricTitle3: String
    var metricValue3: Double
    var unit3: String
    var decimal3: Int
    
    var body: some View {
            VStack {
                HStack {
                    Text(headerTitleText)
                        .font(.title2.weight(.semibold))
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.bottom, 4)
                .foregroundStyle(textGradient)
                
                Divider()
                    .frame(height: 1)
                    .overlay(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    MetricRowView(imageName: imageText1, title: metricTitle1, healthValue: metricValue1, unit: unit1, decimal: decimal1)
                    MetricRowView(imageName: imageText2, title: metricTitle2, healthValue: metricValue2, unit: unit2, decimal: decimal2)
                    MetricRowView(imageName: imageText3, title: metricTitle3, healthValue: metricValue3, unit: unit3, decimal: decimal3)
                }
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                
            }
            .padding(20)
            .foregroundStyle(textGradient)
            .overviewBackground(borderColor: borderColor)
    }
}

#Preview {
    
    let previewGradient = LinearGradient(
        gradient: Gradient(
            colors: [.lightestRed, .lightRed, .mediumRed, .deepRed, .darkRed]),
        startPoint: .top,
        endPoint: .bottom
    )
    HealthTileInfoView(headerTitleText: "Heart Overview", textGradient: previewGradient, borderColor: .red, imageText1: "arrow.down.heart.fill", metricTitle1: "Resting HR", metricValue1: 69, unit1: "bpm", decimal1: 0, imageText2: "heart.circle", metricTitle2: "Heart Rate", metricValue2: 72, unit2: "bpm", decimal2: 0, imageText3: "waveform.path.ecg.rectangle.fill", metricTitle3: "Heart Rate Variability", metricValue3: 220, unit3: "ms", decimal3: 0)
}
