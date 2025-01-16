//
//  DashboardHeaderView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/26/24.
//

import SwiftUI

struct DashboardHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(Constants.todayDateString)")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.gray)
            
            Text("Dashboard")
                .font(.title.bold())
                .foregroundStyle(.white)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
