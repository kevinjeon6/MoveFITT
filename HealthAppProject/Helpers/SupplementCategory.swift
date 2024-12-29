//
//  SupplementCategory.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/28/24.
//

import Foundation

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
    
    var title: String {
        switch self {
        case .proteinPowderBars:
           return "Protein Powders/Bars"
        case .preWorkout:
            return "Pre-Workout"
        case .fatBurners:
            return "Fat Burners"
        case .vitaminsAndMinerals:
            return "Vitamins & Minerals"
        case .nootropics:
            return "Nootropics"
        case .sleep:
            return "Sleep"
        case .healthAndWellness:
            return "Health & Wellness"
        case .intraWorkout:
            return "Intra-Workout"
        case .creatine:
            return "Creatine"
        case .hydration:
            return "Hydration"
        case .aminoAcids:
            return "Amino Acids"
        case .other:
            return "Other"
        }
    }
}

