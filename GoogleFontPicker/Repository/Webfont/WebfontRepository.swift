//
//  WebfontRepository.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import RealmSwift

class WebfontRepository: RealmRepository<String, Webfont, WebfontObject> {
    
    override func identify(_ entity: Webfont) -> String {
        return entity.identifier
    }
    
    override func toRealmObject(_ entity: Webfont) throws -> WebfontObject {
        let result = WebfontObject()
        result.identifier = entity.identifier
        result.providerIdentifier = entity.providerIdentifier
        result.familyName = entity.familyName
        result.variant = entity.variant
        result.onlineUrl = entity.onlineUrl.absoluteString
        result.localFileName = entity.localFileName
        
        return result
    }
    
    override func fromRealmObject(_ object: WebfontObject) throws -> Webfont {
        if let onlineUrl = URL(string: object.onlineUrl) {
            return DefaultWebfont(providerIdentifier: object.providerIdentifier,
                                  familName: object.familyName,
                                  variant: object.variant,
                                  onlineUrl: onlineUrl,
                                  localFileName: object.localFileName)
        } else {
            throw Failure.unexpected
        }
    }
    
}
