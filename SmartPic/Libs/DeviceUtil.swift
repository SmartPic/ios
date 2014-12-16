//
//  DeviceUtil.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/12/16.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class DeviceUtil: NSObject {
    
    /**
     * 使用しているiPhoneのモデルを推定する
     * :returns: 解像度から推定される使用デバイス
     * http://qiita.com/YukiAsu/items/78a5bed63c12660e8024
     */
    func iOSDevice() -> String {
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
