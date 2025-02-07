//
//  SupplementCategory.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/28/24.
//

import Foundation
import SwiftUI

enum SupplementCategory: String, Codable, CaseIterable, Identifiable {
    
    var id: Self { self }
    case proteinPowderBars 
    case preWorkout
    case fatBurners
    case vitaminsAndMinerals
    case nootropics
    case sleep
    case healthAndWellness
    case intraWorkout
    case creatine
    case hydration
    case aminoAcids
    case other
    
    ///Title of the categories
    var title: String {
        switch self {
        case .proteinPowderBars: return "Protein Powders/Bars"
        case .preWorkout: return "Pre-Workout"
        case .fatBurners: return "Fat Burners"
        case .vitaminsAndMinerals: return "Vitamins & Minerals"
        case .nootropics: return "Nootropics"
        case .sleep: return "Sleep"
        case .healthAndWellness: return "Health & Wellness"
        case .intraWorkout: return "Intra-Workout"
        case .creatine: return "Creatine"
        case .hydration: return "Hydration"
        case .aminoAcids: return "Amino Acids"
        case .other: return "Other"
        }
    }
    
    var categoryColor: Color {
        switch self {
        case .proteinPowderBars: return .brown
        case .preWorkout: return .red
        case .fatBurners: return .orange
        case .vitaminsAndMinerals: return .cyan
        case .nootropics: return .mint
        case .sleep: return .purple
        case .healthAndWellness: return .green
        case .intraWorkout: return .yellow
        case .creatine: return .gray
        case .hydration: return .indigo
        case .aminoAcids: return .teal
        case .other: return .black
        }
    }
}

