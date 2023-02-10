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
    var description: String
    var color: Color
    var categoryValue: String?
    
    @State private var showInfoSheet = false
    
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 5)
                .padding(.horizontal)
                .frame(width: 400, height: 80)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: imageText )
                        .foregroundColor(color)
                    Text(title)
                        .font(.title3)
                    Spacer()
                    Button {
                        showInfoSheet.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .sheet(isPresented: $showInfoSheet) {
                        InfoView(description: description)
                            .presentationDetents([.medium])
                    }
                    
                }
                .padding(.trailing, 10)
         
        
                Text(categoryValue ?? "Missing Data")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)
            }
            .padding(.leading)
            .frame(width: 350)
        }
    }
}

struct CurrentSummaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSummaryCardView(title: "Health Type", imageText: "heart.fill", description: "Description Text Here", color: .red)
    }
}
