//
//  ParsedCategory.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 23.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import Foundation
import AEXML

struct ParsedCategory123 {
    var categoryID: String
    var categoryName: String
    
    init(category: AEXMLElement) {
        categoryID = category.attributes["id"]!
        categoryName = category.value!
    }
}
