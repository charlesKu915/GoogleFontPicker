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
    
    var familyName: String { get }
    
    var variant: String { get }
    
    var font: UIFont? { get }
    
    var onlineUrl: URL { get }
    
    var localUrl: URL? { get }
}
