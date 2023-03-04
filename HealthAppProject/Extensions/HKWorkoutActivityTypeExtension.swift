//
//  HKWorkoutActivityTypeExtension.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 2/25/23.
//

import Foundation
import HealthKit
import SwiftUI



extension HKWorkoutActivityType {
    
    // MARK: Retrieve HKWorkoutActivityType extension based on activity type
//     Utilized extension from the works of https://github.com/georgegreenoflondon/HKWorkoutActivityType-Descriptions
    
    var name: String {
         switch self {
         case .americanFootball:             return "American Football"
         case .archery:                      return "Archery"
         case .australianFootball:           return "Australian Football"
         case .badminton:                    return "Badminton"
         case .baseball:                     return "Baseball"
         case .basketball:                   return "Basketball"
         case .bowling:                      return "Bowling"
         case .boxing:                       return "Boxing"
         case .climbing:                     return "Climbing"
         case .cooldown:                     return "Cooldown"
         case .crossTraining:                return "Cross Training"
         case .curling:                      return "Curling"
         case .cycling:                      return "Cycling"
         case .dance:                        return "Dance"
         case .danceInspiredTraining:        return "Dance Inspired Training"
         case .elliptical:                   return "Elliptical"
         case .equestrianSports:             return "Equestrian Sports"
         case .fencing:                      return "Fencing"
         case .fishing:                      return "Fishing"
         case .functionalStrengthTraining:   return "Functional Strength Training"
         case .golf:                         return "Golf"
         case .gymnastics:                   return "Gymnastics"
         case .handball:                     return "Handball"
         case .hiking:                       return "Hiking"
         case .hockey:                       return "Hockey"
         case .hunting:                      return "Hunting"
         case .lacrosse:                     return "Lacrosse"
         case .martialArts:                  return "Martial Arts"
         case .mindAndBody:                  return "Mind and Body"
         case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
         case .paddleSports:                 return "Paddle Sports"
         case .play:                         return "Play"
         case .preparationAndRecovery:       return "Preparation and Recovery"
         case .racquetball:                  return "Racquetball"
         case .rowing:                       return "Rowing"
         case .rugby:                        return "Rugby"
         case .running:                      return "Running"
         case .sailing:                      return "Sailing"
         case .skatingSports:                return "Skating Sports"
         case .snowSports:                   return "Snow Sports"
         case .soccer:                       return "Soccer"
         case .softball:                     return "Softball"
         case .squash:                       return "Squash"
         case .stairClimbing:                return "Stair Climbing"
         case .surfingSports:                return "Surfing Sports"
         case .swimming:                     return "Swimming"
         case .tableTennis:                  return "Table Tennis"
         case .tennis:                       return "Tennis"
         case .trackAndField:                return "Track and Field"
         case .traditionalStrengthTraining:  return "Traditional Strength Training"
         case .volleyball:                   return "Volleyball"
         case .walking:                      return "Walking"
         case .waterFitness:                 return "Water Fitness"
         case .waterPolo:                    return "Water Polo"
         case .waterSports:                  return "Water Sports"
         case .wrestling:                    return "Wrestling"
         case .yoga:                         return "Yoga"
         
         // iOS 10
         case .barre:                        return "Barre"
         case .coreTraining:                 return "Core Training"
         case .crossCountrySkiing:           return "Cross Country Skiing"
         case .downhillSkiing:               return "Downhill Skiing"
         case .flexibility:                  return "Flexibility"
         case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
         case .jumpRope:                     return "Jump Rope"
         case .kickboxing:                   return "Kickboxing"
         case .pilates:                      return "Pilates"
         case .snowboarding:                 return "Snowboarding"
         case .stairs:                       return "Stairs"
         case .stepTraining:                 return "Step Training"
         case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
         case .wheelchairRunPace:            return "Wheelchair Run Pace"
         
         // iOS 11
         case .taiChi:                       return "Tai Chi"
         case .mixedCardio:                  return "Mixed Cardio"
         case .handCycling:                  return "Hand Cycling"
         
         // iOS 13
         case .discSports:                   return "Disc Sports"
         case .fitnessGaming:                return "Fitness Gaming"
         
         // Catch-all
         default:                            return "Other"
         }
     }
    
    var fitnessIcon: Image {
        switch self {
        case .traditionalStrengthTraining:      return Image(systemName: "figure.strengthtraining.traditional")
        case .americanFootball:                 return Image(systemName: "figure.american.football")
        case .archery:                          return Image(systemName: "figure.archery")
        case .australianFootball:               return Image(systemName: "figure.australian.football")
        case .badminton:                        return Image(systemName: "figure.badminton")
        case .baseball:                         return Image(systemName: "figure.baseball")
        case .basketball:                       return Image(systemName: "figure.basketball")
        case .bowling:                          return Image(systemName: "figure.bowling")
        case .boxing:                           return Image(systemName: "figure.boxing")
        case .climbing:                         return Image(systemName: "figure.climbing")
        case .cricket:                          return Image(systemName: "figure.cricket")
        case .crossTraining:                    return Image(systemName: "figure.cross.training")
        case .curling:                          return Image(systemName: "figure.curling")
        case .cycling:                          return Image(systemName: "figure.indoor.cycle")
        case .dance:                            return Image(systemName: "figure.dance")
        case .elliptical:                       return Image(systemName: "figure.elliptical")
        case .equestrianSports:                 return Image(systemName: "figure.equestrian.sports")
        case .fencing:                          return Image(systemName: "figure.fencing")
        case .fishing:                          return Image(systemName: "figure.fishing")
        case .functionalStrengthTraining:       return Image(systemName: "figure.strengthtraining.functional")
        case .golf:                             return Image(systemName: "figure.golf")
        case .gymnastics:                       return Image(systemName: "figure.gymnastics")
        case .handball:                         return Image(systemName: "figure.handball")
        case .hiking:                           return Image(systemName: "figure.hiking")
        case .hockey:                           return Image(systemName: "figure.hockey")
        case .hunting:                          return Image(systemName: "figure.hunting")
        case .lacrosse:                         return Image(systemName: "figure.lacrosse")
        case .martialArts:                      return Image(systemName: "figure.martial.arts")
        case .mindAndBody:                      return Image(systemName: "figure.mind.and.body")
        case .mixedCardio:                      return Image(systemName: "figure.mixed.cardio")
        case .paddleSports:                     return Image(systemName: "oar.2.crossed")
        case .play:                             return Image(systemName: "figure.play")
        case .preparationAndRecovery:           return Image(systemName: "figure.rolling")
        case .racquetball:                      return Image(systemName: "figure.racquetball")
        case .rowing:                           return Image(systemName: "figure.rower")
        case .rugby:                            return Image(systemName: "figure.rugby")
        case .running:                          return Image(systemName: "figure.run")
        case .sailing:                          return Image(systemName: "figure.sailing")
        case .skatingSports:                    return Image(systemName: "figure.skating")
        case .soccer:                           return Image(systemName: "figure.soccer")
        case .softball:                         return Image(systemName: "figure.softball")
        case .squash:                           return Image(systemName: "figure.squash")
        case .stairClimbing:                    return Image(systemName: "figure.stair.stepper")
        case .surfingSports:                    return Image(systemName: "figure.surfing")
        case .swimming:                         return Image(systemName: "figure.pool.swim")
        case .tableTennis:                      return Image(systemName: "figure.table.tennis")
        case .tennis:                           return Image(systemName: "figure.tennis")
        case .trackAndField:                    return Image(systemName: "figure.track.and.field")
        case .volleyball:                       return Image(systemName: "figure.volleyball")
        case .walking:                          return Image(systemName: "figure.walk")
        case .waterFitness:                     return Image(systemName: "figure.water.fitness")
        case .waterPolo:                        return Image(systemName: "figure.waterpolo")
        case .waterSports:                      return Image(systemName: "drop.circle")
        case .wrestling:                        return Image(systemName: "figure.wrestling")
        case .yoga:                             return Image(systemName: "figure.yoga")
        case .barre:                            return Image(systemName: "figure.barre")
        case .coreTraining:                     return Image(systemName: "figure.core.training")
        case .crossCountrySkiing:               return Image(systemName: "figure.skiing.crosscountry")
        case .downhillSkiing:                   return Image(systemName: "figure.skiing.downhill")
        case .flexibility:                      return Image(systemName: "figure.flexibility")
        case .highIntensityIntervalTraining:    return Image(systemName: "figure.highintensity.intervaltraining")
        case .jumpRope:                         return Image(systemName: "figure.jumprope")
        case .kickboxing:                       return Image(systemName: "figure.kickboxing")
        case .pilates:                          return Image(systemName: "figure.pilates")
        case .snowboarding:                     return Image(systemName: "figure.snowboarding")
        case .stairs:                           return Image(systemName: "figure.stairs")
        case .wheelchairWalkPace:               return Image(systemName: "figure.roll")
        case .wheelchairRunPace:                return Image(systemName: "figure.roll.runningpace")
        case .taiChi:                           return Image(systemName: "figure.taichi")
        case .handCycling:                      return Image(systemName: "figure.hand.cycling")
        case .discSports:                       return Image(systemName: "figure.disc.sports")
        case .fitnessGaming:                    return Image(systemName: "gamecontroller.fill")
        case .cardioDance:                      return Image(systemName: "figure.dance")
        case .socialDance:                      return Image(systemName: "figure.socialdance")
        case .pickleball:                       return Image(systemName: "figure.pickleball")
        case .cooldown:                         return Image(systemName: "figure.cooldown")
    //Catch-All
        default:                                return Image(systemName: "")
        }
    }
    
    

}
