//
//  SettingViewController.swift
//  SmartPic
//
//  Created by himara2 on 2014/12/11.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

enum SettingType: Int {
    case Request = 0, Review, Version
    
    static func allValues() -> [SettingType] {
        return [Request, Review, Version]
    }
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - UITableViewDelegate 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingType.allValues().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier = ""
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        
        switch indexPath.row {
        case SettingType.Request.rawValue:
            cellIdentifier = "RequestCell"
        case SettingType.Review.rawValue:
            cellIdentifier = "ReviewCell"
        case SettingType.Version.rawValue:
            cellIdentifier = "VersionCell"
        default:
            cellIdentifier = ""
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        cell.detailTextLabel?.text = version
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "このアプリについて"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case SettingType.Request.rawValue:
            Helpshift.sharedInstance().showConversation(self, withOptions: ["hideNameAndEmail":"YES"])
        case SettingType.Review.rawValue:
            UIApplication.sharedApplication().openURL(NSURL(string: kAppStoreUrl)!)
        default:
            println("do nothing")
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func closeBtnTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
