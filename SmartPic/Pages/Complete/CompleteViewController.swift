//
//  CompleteViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
