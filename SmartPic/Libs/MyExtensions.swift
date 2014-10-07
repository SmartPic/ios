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

class MyExtensions: NSObject {
}
