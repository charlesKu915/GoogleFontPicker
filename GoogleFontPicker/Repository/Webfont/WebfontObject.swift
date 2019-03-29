//
//  WebfontObject.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import RealmSwift

class WebfontObject: Object {
    
    @objc dynamic var identifier: String = ""
    
    @objc dynamic var providerIdentifier: String = ""
    
    @objc dynamic var familyName: String = ""
    
    @objc dynamic var variant: String = ""
    
    @objc dynamic var onlineUrl: String = ""
    
    @objc dynamic var localFileName: String = ""
    
    static override func primaryKey() -> String? {
        return "identifier"
    }
}
