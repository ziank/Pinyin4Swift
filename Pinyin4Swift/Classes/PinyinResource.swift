//
// Created by 翟现旗 on 2017/11/13.
//

import Foundation

class PinyinResource {
    private let kCacheKeyForUnicode2Pinyin:String = "UnicodeToPinyin"
    private let noneStr = "(none0)"

    private var directory:String = ""
    private var _unicodeToHanyuPinyinTable:[String:String] = [:]

    static let instance:PinyinResource = PinyinResource()

    init() {
        initializeResource()
    }

    private func initializeResource() {
        let cachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        directory = "\(cachesDirectory)/\(Bundle.main.bundleIdentifier!)/PinYinCache"
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: directory) {
            do {
                try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
            }
        }

        if let dataMap = cachedObjectForKey(kCacheKeyForUnicode2Pinyin) {
            _unicodeToHanyuPinyinTable = dataMap
        } else {
            if let resourceName = Bundle.myBundle()?.path(forResource: "unicode_to_hanyu_pinyin", ofType: "txt") {
                do {
                    let dictionaryText = try String(contentsOfFile: resourceName, encoding: String.Encoding.utf8)
                    let lines = dictionaryText.split(separator: "\r\n")
                    var tempMap:[String:String] = [:]
                    lines.forEach { substring in
                        let lineComponents = substring.components(separatedBy: .whitespaces)
                        tempMap[lineComponents[0]] = lineComponents[1]
                    }
                    _unicodeToHanyuPinyinTable = tempMap
                    cacheObject(_unicodeToHanyuPinyinTable, forKey:kCacheKeyForUnicode2Pinyin)
                } catch {}
            }
        }
    }

    private func cachedObjectForKey(_ key:String) -> [String:String]? {
        let cachePath = cachedPathForKey(directory, key)
        return NSKeyedUnarchiver.unarchiveObject(withFile: cachePath) as? [String : String]
    }

    private func cacheObject(_ table: [String: String], forKey key: String)  {
        let cachePath = cachedPathForKey(directory, key)
        NSKeyedArchiver.archiveRootObject(table, toFile: cachePath)
    }

    private func cachedPathForKey(_ directory: String, _ key: String) -> String {
        return "\(directory)/\(key)"
    }

    func getPinyinStringArrayWithChar(_ ch:UnicodeScalar) -> [String] {
        guard let pinyinRecord = getPinyinRecordFromCharWithChar(ch)  else { return [] }
        let rangeOfLeftBracket = pinyinRecord.indexOfString("(")
        let rangeOfRightBracket = pinyinRecord.indexOfString(")")
        if let rangeOfLeftBracket = rangeOfLeftBracket, let rangeOfRightBracket = rangeOfRightBracket {
            let stripedString = pinyinRecord[pinyinRecord.index(after: rangeOfLeftBracket)...pinyinRecord.index(before: rangeOfRightBracket)]
            let strArray = stripedString.split(separator: ",")
            var target:[String] = []
            for item in strArray {
                target.append(String(item))
            }
            return target
        } else {
            return []
        }
    }

    private func getPinyinRecordFromCharWithChar(_ ch:UnicodeScalar) -> String? {
        let codepointHexStr = String.init(format: "%X", arguments: [ch.utf16.first!])
        let foundRecord = self._unicodeToHanyuPinyinTable[codepointHexStr]
        return isValidRecord(foundRecord) ? foundRecord : nil
    }

    private func isValidRecord(_ record: String?) -> Bool {
        guard let record = record else { return false }
        guard record != noneStr else { return false }
        return record.hasPrefix("(") && record.hasSuffix(")")
    }
}
