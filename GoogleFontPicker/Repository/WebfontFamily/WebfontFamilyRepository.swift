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
    
    override func toRealmObject(_ entity: WebfontFamily) throws -> WebfontFamilyObject {
        let result = WebfontFamilyObject()
        result.identifier = entity.identifier
        result.providerIdentifier = entity.providerIdentifier
        result.name = entity.name
        result.category = entity.catetory
        result.subsets = entity.subsets.joined(separator: ",")
        result.variants = entity.variants.joined(separator: ",")
        result.version = entity.version
        result.defaultVariant = entity.defaultVariant
        
        return result
    }
    
    override func fromRealmObject(_ object: WebfontFamilyObject) throws -> WebfontFamily {
        return try DefaultWebfontFamily(withRealm: object)
    }
    
}

extension DefaultWebfontFamily {
    
    convenience init(withRealm object: WebfontFamilyObject) throws {
        self.init(providerIdentifier: object.providerIdentifier,
                  familyName: object.name,
                  category: object.category,
                  variants: object.variants.components(separatedBy: ","),
                  subsets: object.subsets.components(separatedBy: ","),
                  version: object.version,
                  defaultVariant: object.defaultVariant)
    }
    
}
