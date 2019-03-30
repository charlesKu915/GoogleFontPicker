//
//  FontFamilyCellCollectionViewCell.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import UIKit

class FontFamilyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var dispalyLabel: UILabel!
    
    var fontInfo: (name: String, font: UIFont)? {
        didSet {
            if let fontInfo = self.fontInfo {
                self.dispalyLabel.font = fontInfo.font
                self.dispalyLabel.adjustsFontForContentSizeCategory = true
                self.dispalyLabel.text = fontInfo.name
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = self.isSelected ? 5.0: 0.0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.ckBlue.cgColor
    }

}
