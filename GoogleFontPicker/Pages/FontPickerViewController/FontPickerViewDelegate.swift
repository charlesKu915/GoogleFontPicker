//
//  FontPickerViewDelegate.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/31.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

/**
 
 */
protocol FontPickerViewDelegate {
    
    func fontPickerView(_ view: FontPickerView, fontFamilySelectedAt index: Int)
    
    func fontPickerView(_ view: FontPickerView, fontVariantSelectedAt index: Int)
    
}
