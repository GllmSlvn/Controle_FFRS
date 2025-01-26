//
//  DailyData+CoreDataProperties.swift
//  FeuilleControle_FFRS
//
//  Created by Guillaume Sylvain on 2025-01-21.
//
//

import Foundation
import CoreData

extension DailyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyData> {
        return NSFetchRequest<DailyData>(entityName: "DailyData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var ermp: Int32
    @NSManaged public var circulaire: Int32
    @NSManaged public var serrures: Int32

}

extension DailyData : Identifiable {

}
