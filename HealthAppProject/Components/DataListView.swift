//
//  DataListView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 2/13/23.
//

import SwiftUI

struct DataListView: View {
    
    var imageText: String
    var imageColor: Color
    var valueText: String
    var date: Date

    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: imageText)
                    .foregroundColor(imageColor)
                Text(valueText)
                    .font(.title2)
                    .bold()
            }
            Text(date, style: .date)
                .opacity(0.5)
        }
    }
}

struct DataListView_Previews: PreviewProvider {
    static var previews: some View {
        DataListView(imageText: "figure.walk", imageColor: .cyan, valueText: "6000", date: Date.now)
    }
}
