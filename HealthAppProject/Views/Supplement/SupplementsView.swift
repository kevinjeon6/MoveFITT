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
    @Query(sort: \SupplementItem.date) var supplement: [SupplementItem]
    
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
                            date: item.date,
                            category: item.supplementCategory.title,
                            categoryStyle: item.supplementCategory
                        )
                        .foregroundStyle(.white)
                    }
                    .listRowSeparatorTint(.white)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(supplement[index])
                    }
                }
                .listRowBackground(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
            }
            .navigationTitle("Supplements")
            .background(Color.black)
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $isShowingAddSupplementSheet) {
                AddSupplementSheet()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !supplement.isEmpty {
                        Button("Add Supplement", systemImage: "plus") {
                            isShowingAddSupplementSheet = true
                        }
                    }
                }
            }
            .overlay {
                if supplement.isEmpty {
                    ContentUnavailableView {
                        Label("No Supplements", systemImage: "list.dash")
                            .foregroundStyle(.white)
                    } description: {
                        Text("Start adding your supplements to the list")
                            .foregroundStyle(.white)
                    } actions: {
                        Button("Add Supplement") {
                            isShowingAddSupplementSheet = true
                        }
                    }
                    .offset(y: -80)
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
