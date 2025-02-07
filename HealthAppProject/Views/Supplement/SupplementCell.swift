//
//  SupplementCell.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/26/24.
//

import SwiftUI

struct SupplementCell: View {
    
    var brandName: String
    var name: String
    var date: Date
    var category: String
    var categoryStyle: SupplementCategory
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(brandName)
                .font(.title2.weight(.black))
            
            Text(name)
                .foregroundStyle(.secondary)
                .font(.callout)
                .bold()
          
            HStack(alignment: .firstTextBaseline) {
                Text(category)
                    .foregroundStyle(categoryStyle.categoryColor)
                    .font(.caption)
                    .fontWeight(.heavy)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 5)
                    .background(
                        categoryStyle.categoryColor.opacity(0.2),
                        in: RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                    )
                Text(date, format: .dateTime.month().day().year())
                    .foregroundStyle(.secondary)
                    .font(.caption2)
            }
        }
    }
}

#Preview {
    SupplementCell(brandName: "Ryse", name: "Pre-Loaded", date: .now, category: "Pre-Workout", categoryStyle: .preWorkout)
}

