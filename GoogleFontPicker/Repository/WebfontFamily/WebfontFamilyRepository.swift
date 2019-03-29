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
        result.lastModified = entity.lastModified
        
        return result
    }
    
    override func fromRealmObject(_ object: WebfontFamilyObject) throws -> WebfontFamily {
        switch object.providerIdentifier {
        case "google":
            return try GoogleWebfontFamily(withRealm: object)
        default:
            throw Failure.unexpected
        }
    }
    
}

extension GoogleWebfontFamily {
    
    convenience init(withRealm object: WebfontFamilyObject) throws {
        self.init(familyName: object.name,
                  category: object.category,
                  variants: object.variants.components(separatedBy: ","),
                  subsets: object.subsets.components(separatedBy: ","),
                  version: object.version,
                  lastModified: Date())
    }
}
