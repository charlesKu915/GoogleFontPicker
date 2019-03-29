//
//  GoogleWebfontProvider.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Alamofire

class GoogleWebfontProvider: WebfontProvider {
    
    var versionComparator: WebfontVersionComparator?
    
    static var providerIdentifier: String {
        return "google"
    }
    
    private var apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchWebfontList(handleBy handler: @escaping FetchWebfontListResultHandler) {
        Alamofire.request("https://www.googleapis.com/webfonts/v1/webfonts?key=\(self.apiKey)").responseJSON { (response) in
            if let object = response.value as? [String: Any],
                let items = object["items"] as? [[String: Any]] {
                var families: [WebfontFamily] = []
                var fonts: [Webfont] = []
                for item in items {
                    do {
                        let family = try DefaultWebfontFamily(with: item)
                        if self.versionComparator?.needUpdage(for: family) ?? true {
                            families.append(family)
                            if let files = item["files"] as? [String: String] {
                                for variant in family.variants {
                                    if let filePath = files[variant], let onlineUrl = URL(string: filePath) {
                                        fonts.append(DefaultWebfont(providerIdentifier: GoogleWebfontProvider.providerIdentifier, familName: family.name, variant: variant, onlineUrl: onlineUrl))
                                    } else {
                                        // Wired... it should not be happened, caused by server error
                                    }
                                }
                            }
                        } else {
                            // No need to append to array because there is no difference with local
                        }
                    } catch {
                        // Issue occured
                    }
                }
                handler(.success(webfontFamilies: families, webfonts: fonts))
            } else if let error = response.error {
                handler(.failed(reason: error))
            }
        }
    }
    
    
    
}
