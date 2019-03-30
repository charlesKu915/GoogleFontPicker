//
//  FontPickerViewController.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import UIKit

class FontPickerViewController: UIViewController {
    
    var webfontManager: WebfontManager? {
        didSet {
            if let webfontManager = self.webfontManager {
                webfontManager.eventListener = self
            }
        }
    }
    
    var families: [WebfontFamily] = []
    
    var totalNeedDownloadCount: Int = 0
    var currentDownloadedCount: Int = 0 {
        didSet {
            if totalNeedDownloadCount > 0 {
                self.fontPickerView.updateProgress(progress: Float(self.currentDownloadedCount)/Float(self.totalNeedDownloadCount))
            }
        }
    }
    var selectedFontFamilyIndex: Int = 0 {
        didSet {
            if let current = self.selectedWebfontFamily {
                self.selectedVariant = current.defaultVariant
            }
        }
    }
    
    var selectedWebfontFamily: WebfontFamily? {
        if self.families.count > self.selectedFontFamilyIndex {
            return self.families[self.selectedFontFamilyIndex]
        } else {
            return nil
        }
    }
    
    var selectedVariant: String = "" {
        didSet {
            self.fontPickerView.currentFontChanged()
        }
    }
    
    var selectedWebfont: Webfont? {
        if let family = self.selectedWebfontFamily {
            return self.webfontManager?.webfont(for: family, with: self.selectedVariant)
        } else {
            return nil
        }
    }
    
    var fontPickerView: FontPickerView {
        return self.view as! FontPickerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.fontPickerView.dataSource = self
        self.fontPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fontPickerView.showLoading()
        self.webfontManager?.fetchWebfontList()
    }
}

// MARK: FontPickerViewController: WebfontManagerEventListener
extension FontPickerViewController: WebfontManagerEventListener {
    
    func webfontManagerFetchListSuccess(_ manager: WebfontManager) {
        self.fontPickerView.hideLoading()
        
        self.families = self.webfontManager?.webfontFamilies ?? []
        self.fontPickerView.reloadFontList()
        for family in self.webfontManager?.webfontFamilies ?? [] {
            if let font = self.webfontManager?.defaultWebfont(for: family) {
                self.webfontManager?.downloadFont(for: font)
                self.totalNeedDownloadCount = self.totalNeedDownloadCount + 1
            } else {
                self.increaseCurrentDownloadCount()
            }
        }
        self.currentDownloadedCount = 0
    }
    
    func webfontManagerFetchListFailed(_ manager: WebfontManager) {
        self.fontPickerView.hideLoading()
        let alert = UIAlertController(title: "ACCESS FAILED", message: "No networking or no assign google api key?", preferredStyle: .actionSheet)
        self.show(alert, sender: nil)
    }
    
    func webfontManager(_ manager: WebfontManager, downloadedWebfont webfont: Webfont) {
        self.increaseCurrentDownloadCount()
        if webfont.identifier == self.selectedWebfont?.identifier ?? "" {
            if let currentFamily = self.selectedWebfontFamily,
                let index = currentFamily.variants.firstIndex(of: webfont.variant) {
                self.fontPickerView.updateFontVariant(at: index)
            }
            self.fontPickerView.currentFontChanged()
        } else if let index = self.families.firstIndex(where: { (family) -> Bool in
            return family.name == webfont.familyName
        }) {
            self.fontPickerView.updateFontFamily(at: index)
        }
        
    }
    
    func increaseCurrentDownloadCount() {
        objc_sync_enter(self)
        self.currentDownloadedCount = self.currentDownloadedCount + 1
        objc_sync_exit(self)
    }
}

// MARK: FontPickerViewController: FontPickerViewDataSource
extension FontPickerViewController: FontPickerViewDataSource {
    
    func fontPickerView(_ view: FontPickerView, currentFontWithSize size: CGFloat) -> UIFont {
        if self.families.count > 0 {
            let currentFamily = self.families[self.selectedFontFamilyIndex]
            if let currentWebfont = self.webfontManager?.webfont(for: currentFamily, with: self.selectedVariant),
                let font = self.webfontManager?.font(of: currentWebfont, size: size) {
                return font
            }
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    func totalFontCountOnFontPickerView(_ view: FontPickerView) -> Int {
        return self.families.count
    }
    
    func fontPickerView(_ view: FontPickerView, webfontFamilyInfoAt index: Int, withFontSize size: CGFloat) -> (name: String, font: UIFont) {
        if let webfontFamily = self.webfontManager?.webfontFamilies[index],
            let webfont = self.webfontManager?.defaultWebfont(for: webfontFamily) {
            let font = self.webfontManager?.font(of: webfont, size: size) ?? UIFont.systemFont(ofSize: size)
            return (webfontFamily.name, font)
        } else {
            return ("*ERROR*", UIFont.systemFont(ofSize: size))
        }
    }
    
    func currentFontVariantCountOnFontPickerView(_ view: FontPickerView) -> Int {
        if let current = self.selectedWebfontFamily {
            return current.variants.count
        } else {
            return 0
        }
    }
    
    func currentFontVariantIndexOnFontPickerView(_ view: FontPickerView) -> Int {
        if let current = self.selectedWebfontFamily {
            if let index = current.variants.firstIndex(of: self.selectedVariant) {
                return index
            }
        }
        return -1
    }
    
    func fontPickerView(_ view: FontPickerView, webfontInfoAt index: Int) -> (variant: String, downloaded: Bool) {
        if let current = self.selectedWebfontFamily {
            let variant = current.variants[index]
            if let webfont = self.webfontManager?.webfont(for: current, with: variant) {
                return (variant, !webfont.localFileName.isEmpty)
            } else {
                fatalError()
            }
        } else {
            fatalError()
        }
    }
}

// MARK: FontPickerViewController:FontPickerViewDelegate
extension FontPickerViewController: FontPickerViewDelegate {
    
    func fontPickerView(_ view: FontPickerView, fontFamilySelectedAt index: Int) {
        self.selectedFontFamilyIndex = index
    }
    
    func fontPickerView(_ view: FontPickerView, fontVariantSelectedAt index: Int) {
        if let family = self.selectedWebfontFamily {
            let variant = family.variants[index]
            self.selectedVariant = variant
            if let webfont = self.selectedWebfont, webfont.localFileName.isEmpty {
                self.webfontManager?.downloadFont(for: webfont)
                self.totalNeedDownloadCount = self.totalNeedDownloadCount + 1
            } else {
                self.fontPickerView.currentFontChanged()
            }
        }
    }
    
}
