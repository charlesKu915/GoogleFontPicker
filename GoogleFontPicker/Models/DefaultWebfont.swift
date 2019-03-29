//
//  GoogleWebfont.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation
import UIKit

class DefaultWebfont: Webfont {
    
    var providerIdentifier: String
    
    var familyName: String
    
    var variant: String
    
    var onlineUrl: URL
    
    var localFileName: String
    
    init(providerIdentifier: String, familName: String, variant: String, onlineUrl: URL, localFileName: String = "") {
        self.providerIdentifier = providerIdentifier
        self.familyName = familName
        self.variant = variant
        self.onlineUrl = onlineUrl
        self.localFileName = localFileName
    }
    
    func updateLocalFileName(localFileName: String) {
        self.localFileName = localFileName
    }
    
}
