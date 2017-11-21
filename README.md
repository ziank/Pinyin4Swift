# Pinyin4Swift

[![CI Status](http://img.shields.io/travis/ziank/Pinyin4Swift.svg?style=flat)](https://travis-ci.org/ziank/Pinyin4Swift)
[![Version](https://img.shields.io/cocoapods/v/Pinyin4Swift.svg?style=flat)](http://cocoapods.org/pods/Pinyin4Swift)
[![License](https://img.shields.io/cocoapods/l/Pinyin4Swift.svg?style=flat)](http://cocoapods.org/pods/Pinyin4Swift)
[![Platform](https://img.shields.io/cocoapods/p/Pinyin4Swift.svg?style=flat)](http://cocoapods.org/pods/Pinyin4Swift)

## 使用说明

使用Pinyin4Swift的方法和Pinyin4Objc类似，因为该库就是从Pinyin4Objc的Swift的版本，所以使用方法就是调用PinyinHelper的对应方法来获取中文的拼音内容。如要获取“我爱中文”的拼音，可以用如下代码：
```
PinyinHelper.getPinyinStringWithString("我爱中文", outputFormat: OutputFormat(vCharType: .uUnicode, caseType: .lower, toneType: .noTone))
```
对应的输出将是
```
wo ai zhong wen 
```
对于多音字，我们可以使用`PinyinHelper.toPinyinStringArrayWithChar`方法来获取对应的多个读音，如“乐”字：
```
PinyinHelper.toPinyinStringArrayWithChar("乐", outputFormat: OutputFormat(vCharType: .uUnicode, caseType: .lower, toneType: .toneMark))
```
将会输出它对应的两个读音：`["lè", "yuè"]`
相对于Pinyin4Objc，Pinyin4Swift新增了获取首字母的功能，可以让用户更方便的进行通讯录检索等功能的开发。
```
PinyinHelper.getHeaderLettersWithString("我是中国人！")
```
的输出将会是`WSZGR`。

## 示例工程

在工程目录下执行`pod install`之后，可以运行`demo`工程，查看具体的使用使用方法。

## 需求

该项目运行需要`Swift 4.0`版本，所以需要工程的`Swift language version`为4.0。

## 安装

`Pinyin4Swift`支持通过 [CocoaPods](http://cocoapods.org)进行安装。
要使用`Pinyin4Swift`，只需要简单的`Podfile`中添加
```ruby
pod 'Pinyin4Swift'
```

## 作者

ziank, zhaixianqi0111@163.com

## License

`Pinyin4Swift`遵循MIT license. 详细内容可查看LICENSE文件。
