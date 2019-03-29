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

    var variantInfo: (variant: String, downloaded: Bool) = ("", false) {
        didSet {
            self.variantLabel.text = self.variantInfo.variant.uppercased()
            self.backgroundColor = self.isSelected ? UIColor.darkGray : (self.variantInfo.downloaded ? UIColor.clear : UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
            self.variantLabel.textColor = self.isSelected ? UIColor.white : UIColor.darkGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = self.isSelected ? UIColor.darkGray : (self.variantInfo.downloaded ? UIColor.clear : UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
            self.variantLabel.textColor = self.isSelected ? UIColor.white : UIColor.darkGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

}
