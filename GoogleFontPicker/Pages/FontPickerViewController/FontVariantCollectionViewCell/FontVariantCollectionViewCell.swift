//
//  FontVariantCollectionViewCell.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import UIKit

class FontVariantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var variantLabel: UILabel!

    var variantInfo: (variant: String, downloaded: Bool)? {
        didSet {
            if let variantInfo = self.variantInfo {
                self.variantLabel.text = variantInfo.variant.uppercased()
                self.backgroundColor = self.isSelected ? .darkGray : (variantInfo.downloaded ? .clear : .ckGray)
                self.variantLabel.textColor = self.isSelected ? .white : .darkGray
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if let variantInfo = self.variantInfo {
                self.backgroundColor = self.isSelected ? .darkGray : (variantInfo.downloaded ? .clear : .ckGray)
                self.variantLabel.textColor = self.isSelected ? .white : .darkGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

}
