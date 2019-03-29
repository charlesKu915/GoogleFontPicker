//
//  FontPickerViewController.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import UIKit

class FontPickerViewController: UIViewController, WebfontManagerEventListener, FontPickerViewDataSource, FontPickerViewDelegate {
    
    var webfontManager: WebfontManager? {
        didSet {
            if let webfontManager = self.webfontManager {
                webfontManager.eventListener = self
            }
        }
    }
    
    var families: [WebfontFamily] = []
    var totalNeedDownloadCount: Int {
        return self.families.count
    }
    var currentDownloadedCount: Int = 0 {
        didSet {
            self.fontPickerView.updateProgress(progress: Float(self.currentDownloadedCount)/Float(self.totalNeedDownloadCount))
        }
    }
    var selectedIndex: Int = 0 {
        didSet {
            if let current = self.selectedWebfontFamily {
                self.selectedVariant = current.defaultVariant
            }
        }
    }
    
    var selectedVariant: String = "" {
        didSet {
            self.fontPickerView.currentFontChanged()
        }
    }
    
    var selectedWebfontFamily: WebfontFamily? {
        if self.families.count > self.selectedIndex {
            return self.families[self.selectedIndex]
        } else {
            return nil
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
    
        // Do any additional setup after loading the view.
        self.fontPickerView.dataSource = self
        self.fontPickerView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fontPickerView.showLoadingView(with: "Fetch font list data...")
        self.webfontManager?.fetchWebfontList()
    }
    
    func webfontManagerFetchListSuccess(_ manager: WebfontManager) {
        self.fontPickerView.hideLoadingView()
        
        self.families = self.webfontManager?.webfontFamilies ?? []
        print("success fetch list with #\(self.families.count)")
        self.fontPickerView.reloadFontList()
        self.currentDownloadedCount = 0
        for family in self.webfontManager?.webfontFamilies ?? [] {
            if let font = self.webfontManager?.defaultWebfont(for: family) {
                self.webfontManager?.downloadFont(for: font)
            } else {
                self.increaseCurrentDownloadCount()
            }
        }
    }
    
    func webfontManagerFetchListFailed(_ manager: WebfontManager) {
        self.fontPickerView.hideLoadingView()
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

    func currentFontOnFontPickerView(_ view: FontPickerView) -> UIFont {
        if self.families.count > 0 {
            let currentFamily = self.families[self.selectedIndex]
            if let currentWebfont = self.webfontManager?.webfont(for: currentFamily, with: self.selectedVariant),
                let font = self.webfontManager?.font(of: currentWebfont, size: 40) {
                return font
            }
        }
        return UIFont.systemFont(ofSize: 40)
    }
    
    func totalFontCountOnFontPickerView(_ view: FontPickerView) -> Int {
        return self.families.count
    }
    
    func fontPickerView(_ view: FontPickerView, webfontFamilyInfoAt index: Int) -> (name: String, font: UIFont?) {
        if let webfontFamily = self.webfontManager?.webfontFamilies[index],
            let webfont = self.webfontManager?.defaultWebfont(for: webfontFamily) {
            let font = self.webfontManager?.font(of: webfont, size: 20) ?? UIFont.systemFont(ofSize: 20)
            return (webfontFamily.name, font)
        } else {
            return ("Error", nil)
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
    
    func fontPickerView(_ view: FontPickerView, fontCellSelectedWith index: Int) {
        self.selectedIndex = index
    }
    
    func fontPickerView(_ view: FontPickerView, fontVariantSelectedWith index: Int) {
        if let family = self.selectedWebfontFamily {
            let variant = family.variants[index]
            self.selectedVariant = variant
            if let webfont = self.selectedWebfont, webfont.localFileName.isEmpty {
                self.webfontManager?.downloadFont(for: webfont)
            } else {
                self.fontPickerView.currentFontChanged()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
