//
//  WebfontManager.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation
import UIKit

protocol WebfontManagerEventListener: class {
    
    func webfontManagerFetchListSuccess(_ manager: WebfontManager)
    
    func webfontManagerFetchListFailed(_ manager: WebfontManager)
    
    func webfontManager(_ manager: WebfontManager, downloadedWebfont webfont: Webfont)
    
}

protocol WebfontManager: class {
    
    var eventListener: WebfontManagerEventListener? { get set }
    
    var webfontFamilies: [WebfontFamily] { get }
    
    func fetchWebfontList()
    
    func defaultWebfont(for family: WebfontFamily) -> Webfont
    
    func webfont(for family: WebfontFamily, with variant: String) -> Webfont?
    
    func font(of webfont: Webfont, size: CGFloat) -> UIFont?
    
    func downloadFont(for webfont: Webfont)
    
}
