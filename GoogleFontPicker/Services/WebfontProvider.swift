//
//  WebFontProvider.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation


protocol WebfontVersionComparator {
    
    func needUpdage(for webfontFamily: WebfontFamily) -> Bool
    
}


enum FetchWebfontListResult {
    case success(webfontFamilies: [WebfontFamily], webfonts: [Webfont])
    case failed(reason: Error)
}
typealias FetchWebfontListResultHandler = (FetchWebfontListResult) -> Void

enum DownloadWebfontResult {
    case success(localUrl: URL)
    case downloading(progress: Double)
    case failed(reason: Error)
}
typealias DownloadWebfontResultHandler = (DownloadWebfontResult) -> Void

protocol WebfontProvider: class {
    
    static var providerIdentifier: String { get }
    
    var versionComparator: WebfontVersionComparator? { get set }
    
    func fetchWebfontList(handleBy handler: @escaping FetchWebfontListResultHandler)
    
}


