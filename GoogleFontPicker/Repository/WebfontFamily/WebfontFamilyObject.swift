//
//  WebfontFamilyObject.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import RealmSwift

class WebfontFamilyObject: Object {
    
    @objc dynamic var identifier: String = ""
    
    @objc dynamic var providerIdentifier: String = ""
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var category: String = ""
    
    @objc dynamic var variants: String = ""
    
    @objc dynamic var subsets: String = ""
    
    @objc dynamic var version: String = ""
    
    @objc dynamic var lastModified: Date = Date()
    
    static override func primaryKey() -> String? {
        return "identifier"
    }
    
}

