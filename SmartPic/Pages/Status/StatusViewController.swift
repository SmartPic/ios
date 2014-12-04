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
    
    private let deleteManager = DeleteManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.layoutMargins = UIEdgeInsetsZero
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
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as StatusCountCell
            cell.countLabel.text = String(deleteManager.deleteAssetIds.count)
            cell.countLabel.sizeToFit()
            return cell
        case 1:
            cellIdentifier = "PhotoSizeCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as StatusSizeCell
            println("size is \(deleteManager.deleteAssetIds.count)")
            cell.sizeLabel.text = deleteManager.deleteAssetFileSize.format("%.1f")
            cell.sizeLabel.sizeToFit()
            return cell
        case 2:
            cellIdentifier = "ExampleMusicCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as StatusMusicCell
            println("music is \(deleteManager.deleteAssetFileSize / 5)")
            cell.musicLabel.text = String(Int(deleteManager.deleteAssetFileSize / 5))
            cell.musicLabel.sizeToFit()
            return cell
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
