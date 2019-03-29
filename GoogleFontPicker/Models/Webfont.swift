//
//  Webfont.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//


import Foundation
import UIKit

protocol Webfont: class {
    
    var identifier: String { get }
    
    var providerIdentifier: String { get }
    
    var familyName: String { get }
    
    var variant: String { get }
    
    var onlineUrl: URL { get }
    
    var localFileName: String { get }
    
}

extension Webfont {
    
    var identifier: String {
        return self.providerIdentifier + ":" + self.familyName + "/" + self.variant
    }
    
}
