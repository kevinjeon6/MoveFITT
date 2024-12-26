//
//  SupplementsView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/24/24.
//

import SwiftUI
import SwiftData

struct SupplementsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var isShowingAddSupplementSheet: Bool = false
    
    ///Query is like FetchRequest in Core Data
    @Query var supplement: [SupplementItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(supplement) { item in
                    NavigationLink {
                        SupplementDetailView(supplement: item)
                    } label: {
                        SupplementCell(
                            brandName: item.brandName,
                            name: item.name,
                            date: item.date
                        )
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(supplement[index])
                    }
                }
            }
            .navigationTitle("Supplements")
            .background(Color.primary)
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $isShowingAddSupplementSheet) {
                AddSupplementSheet()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Supplement", systemImage: "plus") {
                        isShowingAddSupplementSheet = true
                    }
                }
            }
        }
    }
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}

#Preview {
    SupplementsView()
}
