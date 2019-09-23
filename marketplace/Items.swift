//
//  Items.swift
//  marketplace
//
//  Created by Gigarthan Vijayakumaran on 9/23/19.
//  Copyright © 2019 Gigarthan Vijayakumaran. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
  
  @objc dynamic var id = 0
  @objc dynamic var user: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var desc: String = ""
  @objc dynamic var price: String = ""
  @objc dynamic var img: String = ""
  
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  func incrementId() -> Int {
    return (try! Realm().objects(Items.self).max(ofProperty: "id") as Int? ?? 0) + 1
  }
  
}
