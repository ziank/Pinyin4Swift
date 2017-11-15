//
// Created by 翟现旗 on 2017/11/10.
//

import Foundation

class PinyinFormatter {
    static let numbericKeys:[Int] = [
        0x0030, 0x0041, 0x0061, 0x00b2, 0x00b9, 0x00bc, 0x0660, 0x06f0,
        0x0966, 0x09e6, 0x09f4, 0x09f9, 0x0a66, 0x0ae6, 0x0b66, 0x0be7,
        0x0bf1, 0x0bf2, 0x0c66, 0x0ce6, 0x0d66, 0x0e50, 0x0ed0, 0x0f20,
        0x1040, 0x1369, 0x1373, 0x1374, 0x1375, 0x1376, 0x1377, 0x1378,
        0x1379, 0x137a, 0x137b, 0x137c, 0x16ee, 0x17e0, 0x1810, 0x2070,
        0x2074, 0x2080, 0x2153, 0x215f, 0x2160, 0x216c, 0x216d, 0x216e,
        0x216f, 0x2170, 0x217c, 0x217d, 0x217e, 0x217f, 0x2180, 0x2181,
        0x2182, 0x2460, 0x2474, 0x2488, 0x24ea, 0x2776, 0x2780, 0x278a,
        0x3007, 0x3021, 0x3038, 0x3039, 0x303a, 0x3280, 0xff10, 0xff21,
        0xff41];

    static let numbericValues:[unichar] = [
        0x0039, 0x0030, 0x005a, 0x0037, 0x007a, 0x0057, 0x00b3, 0x00b0,
        0x00b9, 0x00b8, 0x00be, 0x0000, 0x0669, 0x0660, 0x06f9, 0x06f0,
        0x096f, 0x0966, 0x09ef, 0x09e6, 0x09f7, 0x09f3, 0x09f9, 0x09e9,
        0x0a6f, 0x0a66, 0x0aef, 0x0ae6, 0x0b6f, 0x0b66, 0x0bf0, 0x0be6,
        0x0bf1, 0x0b8d, 0x0bf2, 0x080a, 0x0c6f, 0x0c66, 0x0cef, 0x0ce6,
        0x0d6f, 0x0d66, 0x0e59, 0x0e50, 0x0ed9, 0x0ed0, 0x0f29, 0x0f20,
        0x1049, 0x1040, 0x1372, 0x1368, 0x1373, 0x135f, 0x1374, 0x1356,
        0x1375, 0x134d, 0x1376, 0x1344, 0x1377, 0x133b, 0x1378, 0x1332,
        0x1379, 0x1329, 0x137a, 0x1320, 0x137b, 0x1317, 0x137c, 0xec6c,
        0x16f0, 0x16dd, 0x17e9, 0x17e0, 0x1819, 0x1810, 0x2070, 0x2070,
        0x2079, 0x2070, 0x2089, 0x2080, 0x215e, 0x0000, 0x215f, 0x215e,
        0x216b, 0x215f, 0x216c, 0x213a, 0x216d, 0x2109, 0x216e, 0x1f7a,
        0x216f, 0x1d87, 0x217b, 0x216f, 0x217c, 0x214a, 0x217d, 0x2119,
        0x217e, 0x1f8a, 0x217f, 0x1d97, 0x2180, 0x1d98, 0x2181, 0x0df9,
        0x2182, 0xfa72, 0x2473, 0x245f, 0x2487, 0x2473, 0x249b, 0x2487,
        0x24ea, 0x24ea, 0x277f, 0x2775, 0x2789, 0x277f, 0x2793, 0x2789,
        0x3007, 0x3007, 0x3029, 0x3020, 0x3038, 0x302e, 0x3039, 0x3025,
        0x303a, 0x301c, 0x3289, 0x327f, 0xff19, 0xff10, 0xff3a, 0xff17,
        0xff5a, 0xff37, ]

    init() {}


    class func formatPinyinWithString(_ pinyinString:String, outputFormat:OutputFormat) -> String {
        var targetString = ""
        if outputFormat.toneType == ToneType.toneMark {
            targetString = pinyinString.replacingOccurrences(of: "u:", with: "v")
            targetString = self.convertToneNumberToToneMarkWithString(targetString)
        } else {
            if outputFormat.toneType == ToneType.noTone {
                targetString = pinyinString.replacingOccurrences(of: "[1-5]", with: "", options: .regularExpression)
            }

            if outputFormat.vCharType == .v {
                targetString = pinyinString.replacingOccurrences(of: "u:", with: "v")
            } else if outputFormat.vCharType == .uUnicode {
                targetString = pinyinString.replacingOccurrences(of: "u:", with: "ü")
            }
        }

        if outputFormat.caseType == .upper {
            targetString = targetString.uppercased()
        }

        return targetString.isEmpty ? pinyinString : targetString
    }

    class func convertToneNumberToToneMarkWithString(_ pinyinStr:String) -> String {
        let lowercasePinyinStr = pinyinStr.lowercased()
        guard lowercasePinyinStr.matchPatternRegexPattern("[a-z]*[1-5]?") else { return lowercasePinyinStr}
        let defaultCharValue = "$"
        var unmarkedVowel = defaultCharValue
        var indexOfUnmarkedVowel:String.Index? = nil
        let charA:String = "a"
        let charE:String = "e"
        let ouStr:String = "ou"
        let allUnmarkedVowelStr = "aeiouv"
        let allMarkedVowelStr = "āáăàaēéĕèeīíĭìiōóŏòoūúŭùuǖǘǚǜü"

        guard lowercasePinyinStr.matchPatternRegexPattern("[a-z]*[1-5]") else { return lowercasePinyinStr.replacingOccurrences(of: "v", with: "ü")}
        let tuneNumber = PinyinFormatter.getNumericValue(lowercasePinyinStr.unicodeScalars.last!.utf16.first!)
        let indexOfA = lowercasePinyinStr.indexOfString(charA)
        let indexOfE = lowercasePinyinStr.indexOfString(charE)
        let ouIndex = lowercasePinyinStr.indexOfString(ouStr)
        if let indexOfA = indexOfA {
            indexOfUnmarkedVowel = indexOfA
            unmarkedVowel = charA
        } else if let indexOfE = indexOfE {
            indexOfUnmarkedVowel = indexOfE
            unmarkedVowel = charE
        } else if let ouIndex = ouIndex {
            indexOfUnmarkedVowel = ouIndex
            unmarkedVowel = ouStr
        } else {
            for i in 0..<lowercasePinyinStr.count {
                let subStr:String = String(lowercasePinyinStr[lowercasePinyinStr.index(lowercasePinyinStr.endIndex, offsetBy: -i)...])
                if subStr.matchPatternRegexPattern("[aeiouv]") {
                    indexOfUnmarkedVowel = lowercasePinyinStr.index(lowercasePinyinStr.endIndex, offsetBy: -i)
                    unmarkedVowel = String(subStr[subStr.startIndex..<subStr.index(after: subStr.startIndex)])
                    break
                }
            }
        }

        if defaultCharValue != unmarkedVowel, let indexOfUnmarkedVowel = indexOfUnmarkedVowel {
            let rowIndex = allUnmarkedVowelStr.indexOfString(unmarkedVowel)
            let columnIndex = tuneNumber - 1
            let vowelLocation = rowIndex!.encodedOffset * 5 + columnIndex
            let index = allMarkedVowelStr.index(allMarkedVowelStr.startIndex, offsetBy: vowelLocation)
            let markedVowel = allMarkedVowelStr[index]
            var resultString = ""
            resultString.append(String(lowercasePinyinStr[..<indexOfUnmarkedVowel]).replacingOccurrences(of: "v", with: "ü"))
            resultString.append(markedVowel)
            resultString.append(String(lowercasePinyinStr[lowercasePinyinStr.index(after: indexOfUnmarkedVowel)..<lowercasePinyinStr.index(before: lowercasePinyinStr.endIndex)]).replacingOccurrences(of: "v", with: "ü"))
            return resultString
        } else {
            return lowercasePinyinStr;
        }
    }

    private class func getNumericValue(_ ch:unichar) -> Int {
        if ch < 128 {
            if ch >= "0".utf16.first! && ch <= "9".utf16.first! {
                return Int(ch - "0".utf16.first!)
            } else if (ch >= "a".utf16.first! && ch <= "z".utf16.first!) {
                return Int(ch - ("a".utf16.first! - 10))
            } else if (ch >= "A".utf16.first! && ch <= "Z".utf16.first!) {
                return Int(ch - ("A".utf16.first! - 10))
            }
            return -1
        }
        let result = self.getIndexOfChar(ch)
        if result >= 0 && ch <= numbericValues[result * 2] {
            let difference = numbericValues[result * 2 + 1]
            if difference == 0 {
                return -2
            }

            if difference > ch {
                return Int(ch) - Int(Int16(difference))
            }

            return Int(ch - difference)
        }
        return -1
    }

    private class func getIndexOfChar(_ ch:unichar) -> Int {
        for index in 0..<numbericKeys.count {
            if numbericKeys[index] == Int(ch) {
                return index
            }
        }
        return -1
    }

}
