//
//  Category.swift
//  Todoey

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>() //Forward Relationship and think of it like an array of Items
}
