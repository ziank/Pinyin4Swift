//
// Created by 翟现旗 on 2017/11/10.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

import Foundation

public enum ToneType {
    case toneNumber
    case noTone
    case toneMark
}

public enum CaseType {
    case upper
    case lower
}

public enum VCharType {
    case uAndColon
    case v
    case uUnicode
}

public class OutputFormat {
    var vCharType:VCharType = .uAndColon
    var caseType:CaseType = .lower
    var toneType:ToneType = .toneNumber


    public static let `default` = OutputFormat()
    init() {}
    public init(vCharType:VCharType, caseType:CaseType, toneType:ToneType) {
        self.vCharType = vCharType
        self.caseType = caseType
        self.toneType = toneType
    }

    func restoreDefault() {
        vCharType = .uAndColon
        caseType = .lower
        toneType = .toneNumber
    }
}
