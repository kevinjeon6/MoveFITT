//
//  SupplementItem.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/24/24.
//

import Foundation
import SwiftData

///This is SwiftData model of the attributes that you want to store
///
@Model
class SupplementItem {
    var brandName: String
    var name: String
    var date: Date
    var image: Data?
    
    
    init(brandName: String, name: String, date: Date, image: Data? = nil) {
        self.brandName = brandName
        self.name = name
        self.date = date
        self.image = image
    }
}
