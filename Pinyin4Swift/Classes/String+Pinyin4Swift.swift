//
// Created by 翟现旗 on 2017/11/10.
//

import Foundation

extension String {
    func indexOfString(_ s:String) -> Index? {
        return self.indexOfString(s, fromIndex: self.startIndex)
    }

    func indexOfString(_ s:String, fromIndex index:Index) -> Index? {
        guard s.count >= 0 else { return nil }
        let searchRange = Range(uncheckedBounds: (index, self.endIndex))
        if let range = self.range(of: s, options: .literal, range: searchRange) {
            return range.isEmpty ? nil : range.lowerBound
        } else {
            return nil
        }
    }

    func matchPatternRegexPattern(_ regex:String) -> Bool {
        return self.matchPatternRegexPattern(regex, caseInsensitive:false, treatAsOneLine:false)
    }

    private func matchPatternRegexPattern(_ regex: String, caseInsensitive: Bool, treatAsOneLine oneLine:Bool) -> Bool {
        var options:NSRegularExpression.Options = NSRegularExpression.Options(rawValue: 0)
        if caseInsensitive {
            options.insert(.caseInsensitive)
        }
        if oneLine {
            options.insert(.dotMatchesLineSeparators)
        }

        do {
            let pattern = try NSRegularExpression(pattern: regex, options: options)
            return pattern.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) > 0
        } catch {
            return false
        }
    }
}