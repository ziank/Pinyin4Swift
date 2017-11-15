//
//  PinyinHelper.swift
//  Pinyin4Swift
//
//  Created by 翟现旗 on 2017/11/10.
//

import UIKit

public typealias OutputStringBlock = (String)->Void
public typealias OutputArrayBlock = ([String]) -> Void

public class PinyinHelper: NSObject {

    //MARK: Async Method
    public class func toPinyinStringArrayWithChar(_ ch:UnicodeScalar, outputBlock:@escaping OutputArrayBlock) {
        return getUnformattedPinyinStringArrayWithChar(ch, outputBlock: outputBlock)
    }
    
    public class func toPinyinStringArrayWithChar(_ ch:UnicodeScalar, outputFormat: OutputFormat, outputBlock:@escaping OutputArrayBlock) {
        return getFormattedPinyinStringArrayWithChar(ch, outputFormat: outputFormat, outputBlock: outputBlock)
    }
    
    public class func getFormattedPinyinStringArrayWithChar(_ ch:UnicodeScalar, outputFormat: OutputFormat, outputBlock:@escaping OutputArrayBlock) {
        getUnformattedPinyinStringArrayWithChar(ch) { strings in
            if strings.isEmpty {
                outputBlock([])
            } else {
                var targetArray:[String] = []
                strings.forEach { s in
                    targetArray.append(PinyinFormatter.formatPinyinWithString(s, outputFormat: outputFormat))
                }
                outputBlock(targetArray)
            }
        }
    }

    public class func getUnformattedPinyinStringArrayWithChar(_ ch:UnicodeScalar, outputBlock:@escaping OutputArrayBlock) {
        DispatchQueue.global().async {
            let array = PinyinResource.instance.getPinyinStringArrayWithChar(ch)
            DispatchQueue.main.async {
                outputBlock(array)
            }
        }
    }

    public class func toPinyinStringWithString(_ str:String, outputFormat:OutputFormat, seperater:String, outputBlock:@escaping OutputStringBlock) {

        DispatchQueue.global().async {
            let resultPinyinStr = toPinyinStringWithString(str, outputFormat: outputFormat, seperater: seperater)
            DispatchQueue.main.async {
                outputBlock(resultPinyinStr)
            }
        }
    }

    public class func getFirstPinyinStringWithChar(_ ch:UnicodeScalar, outputFormat:OutputFormat, outputBlock:@escaping OutputStringBlock) {
        getFormattedPinyinStringArrayWithChar(ch, outputFormat: outputFormat) { strings in
            outputBlock(strings.isEmpty ? "" : strings[0])
        }
    }

    //MARK: Sync Methods
    public class func toPinyinStringArrayWithChar(_ ch: UnicodeScalar, outputFormat:OutputFormat=OutputFormat.default) -> [String] {
        return getFormattedPinyinStringArrayWithChar(ch, outputFormat: outputFormat)
    }

    public class func getFormattedPinyinStringArrayWithChar(_ ch: UnicodeScalar, outputFormat:OutputFormat) -> [String] {
        let stringArray = getUnformattedPinyinStringArrayWithChar(ch)
        if stringArray.isEmpty {
            return []
        } else {
            var targetArray:[String] = []
            stringArray.forEach { s in
                targetArray.append(PinyinFormatter.formatPinyinWithString(s, outputFormat: outputFormat))
            }
            return targetArray
        }
    }

    public class func getUnformattedPinyinStringArrayWithChar(_ ch: UnicodeScalar) -> [String] {
        return PinyinResource.instance.getPinyinStringArrayWithChar(ch)
    }

    public class func toPinyinStringWithString(_ str:String, outputFormat:OutputFormat=OutputFormat.default, seperater:String=" ") -> String {
        var resultPinyinStr = ""
        str.unicodeScalars.forEach { scalar in
            let ch_str = getFirstPinyinStringWithChar(scalar, outputFormat: outputFormat)
            resultPinyinStr += ch_str
            resultPinyinStr += seperater
        }
        return resultPinyinStr
    }

    public class func getFirstPinyinStringWithChar(_ ch: UnicodeScalar, outputFormat:OutputFormat) -> String {
        let pinyinArray = getFormattedPinyinStringArrayWithChar(ch, outputFormat: outputFormat)
        return pinyinArray.isEmpty ? "" : pinyinArray[0]
    }
}
