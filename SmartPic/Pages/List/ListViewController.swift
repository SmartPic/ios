//
//  ListViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/05.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class ListViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var seriesList = [GroupInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Admob 設定
        bannerView.adSize = kGADAdSizeBanner
        bannerView.adUnitID = "ca-app-pub-2967292377011754/2952349221"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.screenName = "リストページ"
        reload()
    }
    
    private func reload() {
        var photoFetcher = PhotoFetcher()
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            seriesList = photoFetcher.targetPhotoGroupingByTime()
        }
        else {
            seriesList = photoFetcher.allPhotoGroupingByTime()
        }
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seriesList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO 動的に高さ計算して返す
        return 110;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ListCell = tableView.dequeueReusableCellWithIdentifier(ListCell.className) as ListCell
        
        let group = seriesList[indexPath.row]
        group.loadAddressStr { (address, error) -> Void in
            if error != nil {
                cell.addressLabel.text = nil
            }
            else {
                cell.addressLabel.text = address
            }
        }
        cell.dateLabel.text = group.dateStrFromDate()
        cell.groupInfo = group
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushDetail", sender: seriesList[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "pushDetail") {
            let detailViewController:DetailViewController = segue.destinationViewController as DetailViewController
            detailViewController.groupInfo = sender as GroupInfo
        }
    }
    

    // MARK: IBAction

    @IBAction func segmentControlChanged(sender: AnyObject) {
        reload()
    }
    
    
}
