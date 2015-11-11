//
//  MRRecommend+CoreDataProperties.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/11.
//  Copyright © 2015年 Joshua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MRRecommend {

    @NSManaged var key   : String?
    @NSManaged var value : NSData?

}
