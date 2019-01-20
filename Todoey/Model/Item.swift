//
//  TodoListItemData.swift

import Foundation

//In last you have to inherte Encodable and Decodable protoclos and Xcode 4 do it with one protocol which is Codable
class Item : Codable {
    
    var itemTitle = ""
    var isChecked = false
    
    init() {
        
    }
  
    
}
