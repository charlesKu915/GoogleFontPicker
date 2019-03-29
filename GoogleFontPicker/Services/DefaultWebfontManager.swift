//
//  DefaultWebfontManager.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation

class DefaultWebfontManager: WebfontManager {
    
    var eventListener: WebfontManagerEventListener?
    
    private var providers: [WebfontProvider] = []
    
    private var familyRepository: WebfontFamilyRepository
    
    init(familyRepository: WebfontFamilyRepository, googleFontApiKey: String) {
        self.familyRepository = familyRepository
        let googleWebfontProvider = GoogleWebfontProvider(apiKey: googleFontApiKey)
        self.providers.append(googleWebfontProvider)
    }
    
    deinit {
        self.providers.removeAll()
    }
    
    func fetchWebfontList() {
        let queue = DispatchQueue.init(label: "fetchList")
        let group = DispatchGroup()
        var success: Bool = true
        for provider in self.providers {
            queue.async {
                group.enter()
                provider.fetchWebfontList(handleBy: { (result) in
                    switch result {
                    case .success(let webFontFamilies, let webfonts):
                        for webfontFamily in webFontFamilies {
                            self.familyRepository.saveOrUpdate(webfontFamily)
                        }
                    case .failed:
                        success = false
                    }
                    group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main) {
            if success {
                self.eventListener?.webfontManagerFetchListSuccess(self)
            } else {
                self.eventListener?.webfontManagerFetchListFailed(self)
            }
        }
        
    }
    
    func downloadFont(for webfont: Webfont) {
        
    }
    
}
