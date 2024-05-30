//
//  HealthInfoTileView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/3/23.
//

import SwiftUI

struct HealthInfoTileView: View {
    var title: String
    var imageText: String
    var color: Color
    var healthValue: Double
    
    
    var body: some View {
       
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: imageText)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            Text("\(healthValue, format: .number.precision(.fractionLength(0)))")
                .font(.largeTitle.bold())
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .frame(width: nil, height: 145)
        .cardBackground()

        
    }
}

struct HealthInfoTileView_Previews: PreviewProvider {
    static var previews: some View {
        HealthInfoTileView(title: "Resting HR", imageText: "heart.fill", color: .red, healthValue: 69)
    }
}
