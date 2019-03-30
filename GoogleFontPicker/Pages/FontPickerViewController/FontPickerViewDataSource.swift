//
//  FontPickerViewDataSource.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/31.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import UIKit

/**
 
 */
protocol FontPickerViewDataSource {
    
    func fontPickerView(_ view: FontPickerView, currentFontWithSize size: CGFloat) -> UIFont
    
    func totalFontCountOnFontPickerView(_ view: FontPickerView) -> Int
    
    func fontPickerView(_ view: FontPickerView, webfontFamilyInfoAt index: Int, withFontSize size: CGFloat) -> (name: String, font: UIFont)
    
    func currentFontVariantCountOnFontPickerView(_ view: FontPickerView) -> Int
    
    func currentFontVariantIndexOnFontPickerView(_ view: FontPickerView) -> Int
    
    func fontPickerView(_ view: FontPickerView, webfontInfoAt index: Int) -> (variant: String, downloaded: Bool)
}
