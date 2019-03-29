//
//  WebfontFamilyRepository.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation
import RealmSwift

class WebfontFamilyRepository: RealmRepository<String, WebfontFamily, WebfontFamilyObject> {
    
    override func identify(_ entity: WebfontFamily) -> String {
        return entity.identifier
    }
    
    override func toRealmObject(_ entity: WebfontFamily) -> WebfontFamilyObject {
        let result = WebfontFamilyObject()
        
        return result
    }
    
    override func fromRealmObject(_ object: WebfontFamilyObject) -> WebfontFamily {
        fatalError()
//        return Authentication(signature: object.signature, issuedBy: object.domain, for: object.key, refreshWith: object.refreshToken)
    }
    
}
