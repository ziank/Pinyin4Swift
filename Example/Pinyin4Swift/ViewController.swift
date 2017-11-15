//
//  ViewController.swift
//  Pinyin4Swift
//
//  Created by ziank on 11/10/2017.
//  Copyright (c) 2017 ziank. All rights reserved.
//

import UIKit
import Pinyin4Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(PinyinHelper.getPinyinStringWithString("天下", outputFormat: OutputFormat(vCharType: .uUnicode, caseType: .lower, toneType: .noTone)))
        
        print(PinyinHelper.toPinyinStringArrayWithChar("乐", outputFormat: OutputFormat(vCharType: .uUnicode, caseType: .lower, toneType: .toneMark)))
        print(PinyinHelper.getHeaderLettersWithString("我爱中国，我爱中华，我是中国人！"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

