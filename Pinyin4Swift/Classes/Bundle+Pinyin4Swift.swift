//
//  Bundle+Pinyin4Swift.swift
//  Pinyin4Swift
//
//  Created by 翟现旗 on 2017/11/15.
//

import Foundation

extension Bundle {
    class func myBundle() -> Bundle? {
        return Bundle(for: PinyinHelper.self)
    }
}
