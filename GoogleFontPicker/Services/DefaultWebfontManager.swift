//
//  DefaultWebfontManager.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/28.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation
import Alamofire

class DefaultWebfontManager: WebfontManager {
    
    var eventListener: WebfontManagerEventListener?
    
    var webfontFamilies: [WebfontFamily] {
        return self.familyRepository.getAll()
    }
    
    // Array to store all providers
    private var providers: [WebfontProvider] = []
    
    // Used to save webfont families to local database
    private var familyRepository: WebfontFamilyRepository
    
    // Used to save webfont to local database
    private var fontRepository: WebfontRepository
    
    // The map of identifier of webfont with loading font name
    private var loadFontNameMap: [String: String] = [:]
    
    private var fontRefMap: [String: CGFont] = [:]
    
    private var inMemoryFont: [String] = []
    
    /**
     
     */
    init(familyRepository: WebfontFamilyRepository,
         fontRepository: WebfontRepository,
         googleFontApiKey: String) {
        self.familyRepository = familyRepository
        self.fontRepository = fontRepository
        let googleWebfontProvider = GoogleWebfontProvider(apiKey: googleFontApiKey)
        self.providers.append(googleWebfontProvider)
        for provider in self.providers {
            provider.versionComparator = self
        }
    }
    
    deinit {
        self.providers.removeAll()
    }
    
    /*
     
     */
    func fetchWebfontList() {
        let queue = DispatchQueue.init(label: "fetchList")
        let group = DispatchGroup()
        var success: Bool = true
        for provider in self.providers {
            group.enter()
            queue.async {
                provider.fetchWebfontList(handleBy: { (result) in
                    switch result {
                    case .success(let webFontFamilies, let webfonts):
                        for webfontFamily in webFontFamilies {
                            self.familyRepository.saveOrUpdate(webfontFamily)
                            
                        }
                        for webfont in webfonts {
                            self.fontRepository.saveOrUpdate(webfont)
                        }
                    case .failed:
                        success = false
                    }
                    group.leave()
                })
            }
        }
        
        group.notify(queue: .main) {
            if success {
                self.eventListener?.webfontManagerFetchListSuccess(self)
            } else {
                self.eventListener?.webfontManagerFetchListFailed(self)
            }
        }
        
    }
    
    func defaultWebfont(for family: WebfontFamily) -> Webfont {
        if let webfont = self.webfont(for: family, with: family.defaultVariant) {
            return webfont
        } else {
            fatalError()
        }
    }
    
    func webfont(for family: WebfontFamily, with variant: String) -> Webfont? {
        let identifier = "\(family.identifier)[\(variant)]"
        return self.fontRepository.get(identified: identifier)
    }
    
    func font(of webfont: Webfont, size: CGFloat) -> UIFont? {
        if let loadFontName = self.loadFontNameMap[webfont.identifier] {
            return UIFont(name: loadFontName, size: size)
        } else {
            let loadFontName = self.loadFont(of: webfont)
            return UIFont(name: loadFontName, size: size)
        }
    }
    
    private func loadFont(of webfont: Webfont) -> String {
        do {
            if !webfont.localFileName.isEmpty {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("\(webfont.providerIdentifier)/\(webfont.localFileName)")
                if let fontData = try? Data(contentsOf: fileURL) as CFData,
                    let dataProvider = CGDataProvider(data: fontData) {
                    let fontRef = CGFont(dataProvider)
                    var fontError: Unmanaged<CFError>?
                    if CTFontManagerRegisterGraphicsFont(fontRef!, &fontError) {
                        if let postScriptName = fontRef?.postScriptName as String? {
                            self.fontRefMap[webfont.identifier] = fontRef
                            self.loadFontNameMap[webfont.identifier] = postScriptName
                            return postScriptName
                        }
                    }
                }
            }
        }
        return ""
    }
    
    private func releaseFont(of webfont: Webfont) {
        if let fontRef = self.fontRefMap[webfont.identifier] {
            var fontError: Unmanaged<CFError>?
            if CTFontManagerUnregisterGraphicsFont(fontRef, &fontError) {
                self.loadFontNameMap.removeValue(forKey: webfont.identifier)
            }
        }
    }
    
    func downloadFont(for webfont: Webfont) {
        guard webfont.localFileName.isEmpty else { return }
        self.download(font: webfont) { (result) in
            switch result {
            case .success(let localUrl):
                if let webfont = webfont as? DefaultWebfont {
                    webfont.updateLocalFileName(localFileName: localUrl.lastPathComponent)
                    self.fontRepository.saveOrUpdate(webfont)
                    self.eventListener?.webfontManager(self, downloadedWebfont: webfont)
                }
            case .downloading:
                break
            case .failed:
                print("fail to download \(webfont.identifier)")
            }
        }
    }
    
    private func download(font: Webfont, handleBy handler: @escaping DownloadWebfontResultHandler) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(font.providerIdentifier)/\(font.onlineUrl.lastPathComponent)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(font.onlineUrl, to: destination).downloadProgress { p in
            handler(.downloading(progress: Double(p.completedUnitCount)/Double(p.totalUnitCount)))
        }.response { response in
            if let error = response.error {
                handler(.failed(reason: error))
            } else if let localUrl = response.destinationURL {
                handler(.success(localUrl: localUrl))
            } else {
                handler(.failed(reason: Failure.unexpected))
            }
        }
    }
}

extension DefaultWebfontManager: WebfontVersionChecker {
    
    func needUpdate(for webfontFamily: WebfontFamily) -> Bool {
        if let local = self.familyRepository.get(identified: webfontFamily.identifier) {
            return local.version != webfontFamily.version
        } else {
            return true
        }
        
    }
    
}
