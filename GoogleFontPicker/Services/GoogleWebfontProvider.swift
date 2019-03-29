//
//  GoogleWebfontProvider.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Alamofire

class GoogleWebfontProvider: WebfontProvider {
    
    var webfontFamilies: [WebfontFamily] {
        return []
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
                for item in items {
                    do {
                        let family = try GoogleWebfontFamily(with: item)
                        families.append(family)
                    } catch {
                        print("format issue")
                    }
                }
                handler(.success(webfontFamilies: families, webfonts: []))
            } else if let error = response.error {
                handler(.failed(reason: error))
            }
        }
    }
    
    func download(font: Webfont, handleBy handler: @escaping DownloadWebfontResultHandler) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(font.onlineUrl.lastPathComponent)\(font.onlineUrl.pathExtension)")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(font.onlineUrl, to: destination).downloadProgress { progress in
            
        }.responseJSON { response in
            
        }
    }
    
}
