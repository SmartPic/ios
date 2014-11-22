//
//  StatusViewController.swift
//  SmartPic
//
//  Created by himara2 on 2014/11/22.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        var cellIdentifier = ""
        switch indexPath.row {
        case 0:
            cellIdentifier = "PhotoCountCell"
        case 1:
            cellIdentifier = "PhotoSizeCell"
        case 2:
            cellIdentifier = "ExampleMusicCell"
        default:
            cellIdentifier = ""
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        return cell
    }
    
    
    // MARK: - IBAction
    
    @IBAction func closeBtnTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
