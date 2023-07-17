//
//  YearAndMonth.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 7/10/23.
//

import Foundation


struct YearAndMonth: Comparable, Hashable {
    // MARK: - Properties
    let month: Int
    let year: Int
    
    init(date: Date) {
            let comps = Calendar.current.dateComponents([.year, .month], from: date)
            self.year = comps.year!
            self.month = comps.month!
        }

    
    /// - Parameters:
    ///   - lhs: Left hand side
    ///   - rhs: Right hand side
    //The tuple is comparing the year property first. If they aren't equal then it will sort based on >.
    //If they are equal, it will move to the next pair of elements (the month) and compare the month property

    static func < (lhs: YearAndMonth, rhs: YearAndMonth) -> Bool {
     
        return (lhs.year, lhs.month) > (rhs.year, rhs.month)
    }
    
   
}

extension YearAndMonth {
   
      func monthName() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM" //Setting the dateFormat property to a specific string format
          guard let date = Calendar.current.date(from: DateComponents(year: year, month: month)) else {
                     fatalError("Invalid date components")
                 }
            return dateFormatter.string(from: date)
        }
    
}

