//
//  WebFontFamily.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation

protocol WebfontFamily: class {
    
    var identifier: String { get }
    
    var providerIdentifier: String { get }
    
    var name: String { get }
    
    var catetory: String { get }
    
    var variants: [String] { get }
    
    var subsets: [String] { get }
    
    var version: String { get }
    
    var defaultVariant: String { get }
    
}

extension WebfontFamily {
    
    var identifier: String {
        return "\(self.providerIdentifier)|\(self.name)"
    }
    
}
