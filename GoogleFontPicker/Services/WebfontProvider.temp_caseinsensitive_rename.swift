//
//  WebFontProvider.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//


enum FetchWebFontListResult {
    case success(webfontFamilies: [WebfontFamily])
    case failed(reason: Error)
}

typealias WebFontListResultHandler = (FetchWebFontListResult) -> Void

protocol WebFontProvider: class {
    
    func fetchWebFontList(handleBy handler: @escaping WebFontListResultHandler)
    
}
