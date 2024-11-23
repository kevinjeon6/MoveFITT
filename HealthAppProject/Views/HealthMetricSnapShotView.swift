//
//  HealthMetricSnapShotView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/11/24.
//

import SwiftUI

struct HealthMetricSnapShotView<Content: View>: View {
    
    var title: String
    var textGradient: LinearGradient
    var borderColor: Color
    let content: Content
    
    init(title: String, textGradient: LinearGradient, borderColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.textGradient = textGradient
        self.borderColor = borderColor
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    //Go to charts of the HealthMetric
                } label: {
                    HStack {
                        Text(title)
                            .font(.title2.weight(.semibold))
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.bottom, 4)
                }
                .foregroundStyle(textGradient)
                
                Divider()
                    .frame(height: 1)
                    .overlay(.white)
                
             
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)

            }
            .padding(20)
            .foregroundStyle(textGradient)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                    .shadow(color: borderColor.opacity(0.1), radius: 10, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor.opacity(0.2), lineWidth: 2)
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

    HealthMetricSnapShotView(title: "Heart Overview", textGradient: previewGradient, borderColor: .red) {
        VStack {
            Text("RHR")
            Text("HR")
            Text("HRV")
        }
    }
}
