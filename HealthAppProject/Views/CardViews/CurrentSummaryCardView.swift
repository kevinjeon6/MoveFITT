//
//  CurrentSummaryCardView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/30/22.
//

import SwiftUI

struct CurrentSummaryCardView: View {
    var title: String
    var imageText: String
    var color: Color
    var categoryValue: String
    
   
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.darkModeColor)
                .shadow(color: .black.opacity(0.5), radius: 5)
                .padding(.horizontal)
                .frame(width: 400, height: 80)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: imageText)
                        .foregroundColor(color)
                    Text(title)
                        .font(.title3)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.forward")
                    
                }
                .padding(.trailing, 10)
         
        
                Text("\(categoryValue)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(.bottom, 5)
            }
            .padding(.leading)
            .frame(width: 350)
        }
    }
}

struct CurrentSummaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSummaryCardView(title: "Health Type", imageText: "heart.fill", color: .red, categoryValue: "63")
    }
}
