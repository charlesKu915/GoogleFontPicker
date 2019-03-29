//
//  GoogleWebfontFamily.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation

class GoogleWebfontFamily: WebfontFamily {
    
    var providerIdentifier: String {
        return "google"
    }
    
    var name: String
    
    var catetory: String
    
    var variants: [String]
    
    var subsets: [String]
    
    var lastModified: Date
    
    var version: String
    
//    private var defaultVariant: String
    
    var defaultWebfont: Webfont {
        fatalError()
    }
    
    func webFont(variant: String) -> Webfont? {
        return nil
    }
    
    convenience init(with item: [String: Any]) throws {
        if let familyName = item["family"] as? String,
            let category = item["category"] as? String,
            let variants = item["variants"] as? [String],
            let subsets = item["subsets"] as? [String],
            let version = item["version"] as? String,
            let lastModified = item["lastModified"] as? String,
            let files = item["files"] as? [String: String] {
            self.init(familyName: familyName, category: category, variants: variants, subsets: subsets, version: version, lastModified: Date())
        } else {
            throw Failure.googleItemFormatMappingIssue
        }
    }
    
    init(familyName: String, category: String, variants: [String], subsets: [String], version: String, lastModified: Date) {
        self.name = familyName
        self.catetory = category
        self.variants = variants
        self.subsets = subsets
        self.version = version
        self.variants = variants
        self.lastModified = Date()
    }
}
