//
//  Translation.swift
//  LingoBook
//
//  Created by Connor Goddard on 29/03/2016.
//  Copyright © 2016 Connor Goddard. All rights reserved.
//

import Foundation

struct Translation {
    
    var textValue: String
    
    var locale: String
    
    init(textValue: String, locale: String) {
        
        self.textValue = textValue
        self.locale = locale
    }
    
}