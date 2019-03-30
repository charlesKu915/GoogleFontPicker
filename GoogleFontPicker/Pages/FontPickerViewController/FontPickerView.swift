//
//  FontPickerView.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import UIKit

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
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
}

class FontPickerView: UIView {
    
    private let ShowLabelFontSize: CGFloat = 40.0
    
    private let FontFamilyNameFontSize: CGFloat = 18.0
    
    private let VariantCollectionViewHeight: CGFloat = 50.0
    
    private let FontFamilyCellIdentifier: String = "FontFamilyCollectionViewCell"
    
    private let FontVariantCellIdentifier: String = "FontVariantCollectionViewCell"
    
    @IBOutlet private weak var loadingMask: UIView!
    
    @IBOutlet private weak var loadingActivityView: UIActivityIndicatorView!
    
    @IBOutlet private weak var progressBar: UIProgressView!
    
    @IBOutlet private weak var showLabel: UILabel!
    
    @IBOutlet private weak var fontFamilyCollectionView: UICollectionView!
    
    @IBOutlet private weak var fontVariantsCollectionView: UICollectionView!
    
    public var dataSource: FontPickerViewDataSource? {
        didSet {
            self.reloadFontList()
        }
    }
    
    public var delegate: FontPickerViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fontFamilyCollectionView.collectionViewLayout = FontFamilyLayoutFlow()
        self.fontFamilyCollectionView.register(UINib.init(nibName: FontFamilyCellIdentifier, bundle: nil), forCellWithReuseIdentifier: FontFamilyCellIdentifier)
        self.fontFamilyCollectionView.dataSource = self
        self.fontFamilyCollectionView.delegate = self
        
        self.fontVariantsCollectionView.collectionViewLayout = FontVariantLayoutFlow()
        self.fontVariantsCollectionView.register(UINib.init(nibName: FontVariantCellIdentifier, bundle: nil), forCellWithReuseIdentifier: FontVariantCellIdentifier)
        self.fontVariantsCollectionView.dataSource = self
        self.fontVariantsCollectionView.delegate = self
    }
    
    
    func showLoading() {
        self.loadingMask.isHidden = false
        self.loadingActivityView.startAnimating()
    }
    
    func hideLoading() {
        self.loadingMask.isHidden = true
        self.loadingActivityView.stopAnimating()
    }
    
    func updateProgress(progress: Float) {
        if progress >= 1.0  || progress == 0.0 {
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
        self.showLabel.font = self.dataSource?.fontPickerView(self, currentFontWithSize: ShowLabelFontSize) ?? UIFont.systemFont(ofSize: ShowLabelFontSize)
    }
    
}

extension FontPickerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.fontFamilyCollectionView {
            return self.dataSource?.totalFontCountOnFontPickerView(self) ?? 0
        } else {
            return self.dataSource?.currentFontVariantCountOnFontPickerView(self) ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.fontFamilyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FontFamilyCellIdentifier, for: indexPath) as! FontFamilyCollectionViewCell
            cell.fontInfo = self.dataSource?.fontPickerView(self, webfontFamilyInfoAt: indexPath.item, withFontSize: FontFamilyNameFontSize) ??
                (name: "*ERROR*", font: UIFont.systemFont(ofSize: FontFamilyNameFontSize))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FontVariantCellIdentifier, for: indexPath) as! FontVariantCollectionViewCell
            cell.variantInfo = self.dataSource?.fontPickerView(self, webfontInfoAt: indexPath.item) ?? ("", false)
            return cell
        }
    }
    
}

extension FontPickerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.fontFamilyCollectionView {
            self.delegate?.fontPickerView(self, fontFamilySelectedAt: indexPath.item)
            self.fontVariantsCollectionView.reloadData()
            self.fontVariantsCollectionView.selectItem(at: IndexPath(item: self.dataSource?.currentFontVariantIndexOnFontPickerView(self) ?? 0, section: 0), animated: false, scrollPosition: .top)
        } else {
            self.delegate?.fontPickerView(self, fontVariantSelectedAt: indexPath.item)
        }
    }
    
}
