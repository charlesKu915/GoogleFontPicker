//
//  GoogleWebfontFamily.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation

class DefaultWebfontFamily: WebfontFamily {
    
    var providerIdentifier: String
    
    var name: String
    
    var catetory: String
    
    var variants: [String]
    
    var subsets: [String]
    
    var version: String
    
    var defaultVariant: String
        
    convenience init(with item: [String: Any]) throws {
        if let familyName = item["family"] as? String,
            let category = item["category"] as? String,
            let variants = item["variants"] as? [String],
            let subsets = item["subsets"] as? [String],
            let version = item["version"] as? String {
            var defaultVariant = variants.first
            if variants.contains("regular") {
                defaultVariant = "regular"
            }
            self.init(providerIdentifier: "google", familyName: familyName, category: category, variants: variants, subsets: subsets, version: version, defaultVariant: defaultVariant ?? "")
        } else {
            throw Failure.googleItemFormatMappingIssue
        }
    }
    
    init(providerIdentifier: String, familyName: String, category: String, variants: [String], subsets: [String], version: String, defaultVariant: String) {
        self.providerIdentifier = providerIdentifier
        self.name = familyName
        self.catetory = category
        self.variants = variants.sorted()
        self.subsets = subsets
        self.version = version
        self.variants = variants
        self.defaultVariant = defaultVariant
    }
}
