//
//  MyExtensions.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

// show className
extension NSObject {
    public class var className:String {
        get {
            return NSStringFromClass(self).componentsSeparatedByString(".").last!
        }
    }
}

extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

extension Float {
    func format(formatedString: String) -> String {
        let str: NSString = NSString(format: formatedString, self)
        return str
    }
}

extension NSDate {
    // 日付が同じかどうか
    func isEqualToDateWithoutTime(compareDate: NSDate) -> Bool {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let compareDateStr: String = dateFormatter.stringFromDate(compareDate)
        let selfDateStr: String = dateFormatter.stringFromDate(self)
        
        return selfDateStr == compareDateStr
    }
}

extension UIDevice {
    
    /**
     * 使用しているiPhoneのモデルを推定する
     * :returns: 解像度から推定される使用デバイス
     * http://qiita.com/YukiAsu/items/78a5bed63c12660e8024
     */
    func segmentName() -> String {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if 1.0 < UIScreen.mainScreen().scale {
                let size = UIScreen.mainScreen().bounds.size
                let scale = UIScreen.mainScreen().scale
                let result = CGSizeMake(size.width * scale, size.height * scale)
                switch result.height {
                case 960:
                    return "iPhone4/4S"
                case 1136:
                    return "iPhone5/5s/5c"
                case 1334:
                    return "iPhone6"
                case 1920:
                    return "iPhone6 Plus"
                default:
                    return "unknown"
                }
            } else {
                return "iPhone3"
            }
        } else {
            if 1.0 < UIScreen.mainScreen().scale {
                return "iPad Retina"
            } else {
                return "iPad"
            }
        }
    }
}