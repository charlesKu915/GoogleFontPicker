//
//  FontPickerView.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import UIKit

protocol FontPickerViewDataSource {
    
    func currentFontOnFontPickerView(_ view: FontPickerView) -> UIFont
    
    func totalFontCountOnFontPickerView(_ view: FontPickerView) -> Int
    
    func fontPickerView(_ view: FontPickerView, webfontFamilyInfoAt index: Int) -> (name: String, font: UIFont?)
    
    func currentFontVariantCountOnFontPickerView(_ view: FontPickerView) -> Int
    
    func currentFontVariantIndexOnFontPickerView(_ view: FontPickerView) -> Int
    
    func fontPickerView(_ view: FontPickerView, webfontInfoAt index: Int) -> (variant: String, downloaded: Bool)
}

protocol FontPickerViewDelegate {
    
    func fontPickerView(_ view: FontPickerView, fontCellSelectedWith index: Int)
    
    func fontPickerView(_ view: FontPickerView, fontVariantSelectedWith index: Int)
    
}

class FontFamilyLayoutFlow: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.itemSize = CGSize(width: 175, height: 50)
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

class FontVariantLayoutFlow: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.itemSize = CGSize(width: 100, height: 40)
        self.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
}

class FontPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet private weak var loadingMask: UIView!
    
    @IBOutlet private weak var loadingActivityView: UIActivityIndicatorView!
    
    @IBOutlet private weak var progressBar: UIProgressView!
    
    @IBOutlet private weak var showLabel: UILabel!
    
    @IBOutlet private weak var fontFamilyCollectionView: UICollectionView!
    
    @IBOutlet private weak var fontVariantsCollectionView: UICollectionView!
    
    public var dataSource: FontPickerViewDataSource? {
        didSet {
            
        }
    }
    
    private var currentIndex: Int = 0
    
    public var delegate: FontPickerViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fontFamilyCollectionView.collectionViewLayout = FontFamilyLayoutFlow()
        self.fontFamilyCollectionView.register(UINib.init(nibName: "FontFamilyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FontFamilyCollectionViewCell")
        self.fontFamilyCollectionView.dataSource = self
        self.fontFamilyCollectionView.delegate = self
        
        self.fontVariantsCollectionView.collectionViewLayout = FontVariantLayoutFlow()
        self.fontVariantsCollectionView.register(UINib.init(nibName: "FontVariantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FontVariantCollectionViewCell")
        self.fontVariantsCollectionView.dataSource = self
        self.fontVariantsCollectionView.delegate = self
        
    }
    
    
    func showLoadingView(with text: String) {
        self.loadingMask.isHidden = false
        self.loadingActivityView.startAnimating()
    }
    
    func hideLoadingView() {
        self.loadingMask.isHidden = true
        self.loadingActivityView.stopAnimating()
    }
    
    func updateProgress(progress: Float) {
        if progress >= 1.0 {
            self.progressBar.isHidden = true
        } else {
            self.progressBar.isHidden = false
            self.progressBar.progress = progress
        }
    }
    
    func reloadFontList() {
        self.fontFamilyCollectionView.reloadData()
    }
    
    func updateFontFamily(at index: Int) {
        self.fontFamilyCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func updateFontVariant(at index: Int) {
        var needSelectBack: Bool = false
        if let indexPath = self.fontVariantsCollectionView.indexPathsForSelectedItems?.first {
            needSelectBack = indexPath.item == index
        }
        self.fontVariantsCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        if needSelectBack {
            self.fontVariantsCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    func currentFontChanged() {
        self.showLabel.font = self.dataSource?.currentFontOnFontPickerView(self) ?? UIFont.systemFont(ofSize: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.fontFamilyCollectionView {
            return self.dataSource?.totalFontCountOnFontPickerView(self) ?? 0
        } else {
            return self.dataSource?.currentFontVariantCountOnFontPickerView(self) ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.fontFamilyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontFamilyCollectionViewCell", for: indexPath) as! FontFamilyCollectionViewCell
            cell.fontInfo = self.dataSource?.fontPickerView(self, webfontFamilyInfoAt: indexPath.item) ?? ("Error", nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontVariantCollectionViewCell", for: indexPath) as! FontVariantCollectionViewCell
            cell.variantInfo = self.dataSource?.fontPickerView(self, webfontInfoAt: indexPath.item) ?? ("", false)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
    
//    var needHold: Bool = false
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if collectionView == self.fontVariantsCollectionView {
//            if let info = self.dataSource?.fontPickerView(self, webfontInfoAt: indexPath.item),
//                info.downloaded == false {
//                self.needHold = true
//                return false
//            } else {
//                return true
//            }
//        } else {
//            return true
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.fontFamilyCollectionView {
            self.delegate?.fontPickerView(self, fontCellSelectedWith: indexPath.item)
            self.fontVariantsCollectionView.reloadData()
            self.fontVariantsCollectionView.selectItem(at: IndexPath(item: self.dataSource?.currentFontVariantIndexOnFontPickerView(self) ?? 0, section: 0), animated: false, scrollPosition: .top)
        } else {
            self.delegate?.fontPickerView(self, fontVariantSelectedWith: indexPath.item)
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
