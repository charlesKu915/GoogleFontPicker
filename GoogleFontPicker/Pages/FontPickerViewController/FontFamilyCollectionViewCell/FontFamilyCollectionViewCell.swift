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
    
    var fontInfo: (name: String, font: UIFont?) = ("", nil) {
        didSet {
            if let label = self.dispalyLabel {
                label.font = self.fontInfo.font ?? UIFont.systemFont(ofSize: 10)
                label.adjustsFontForContentSizeCategory = true
                label.text = self.fontInfo.name
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
        self.layer.borderColor = UIColor(red: 21.0/255.0, green: 31.0/255.0, blue: 44.0/255.0, alpha: 1).cgColor
    }

}
