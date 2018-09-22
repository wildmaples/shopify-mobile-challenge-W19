//
//  Product.swift
//  TagsAndProductList
//
//  Created by maple peijune on 2018-09-22.
//  Copyright © 2018 maple peijune. All rights reserved.
//

import Foundation

class Product {
    var id: Int
    var title: String
    //    var body_html: String
    var vendor: String
    var product_type: String
    //    var created_at: Date
    //    var updated_at: Date
    //    var published_at: Date
    var tags: [String]
    var variants: [[String:Any]]
    var inventory: Int?
    var imageURL: String?
    
    init(_ dictionary: [String:Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.vendor = dictionary["vendor"] as? String ?? "Unknown Vendor"
        self.product_type = dictionary["product_type"] as? String ?? "Unknown Product Type"
        
        let makeTags = { (_ tags: String?) -> [String] in
            guard let tags = tags else {
                return []
            }
            return tags.components(separatedBy: ", ")
        }
        
        self.tags = makeTags(dictionary["tags"] as? String ?? nil)
        self.variants = dictionary["variants"] as? [[String:Any]] ?? []
        
        if let image = dictionary["image"] as? [String:Any] {
            self.imageURL = image["src"] as? String ?? ""
        }
    }
    
    func countInventory() {
        for variant in variants { // list of variants
            var totalItem = 0
            if let count = variant["inventory_quantity"] as? Int {
                totalItem += count
            }
            inventory = totalItem
        }
    }
}
