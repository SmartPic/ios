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
    @IBOutlet weak var startButton: UIButton!
    
    private var seriesList = [GroupInfo]()
    private let photoFetcher = PhotoFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIRefreshControl
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        // Admob 設定
        bannerView.adSize = kGADAdSizeBanner
        bannerView.adUnitID = "ca-app-pub-2967292377011754/2952349221"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.screenName = "リストページ"
        
        if photoFetcher.isFinishPhotoLoading {
            startButton.hidden = true
            reload()
        }
        else {
            tableView.hidden = true
        }
    }
    
    private func reload() {
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
        
        cell.addressLabel.text = nil
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
    
    // プルダウンリフレッシュで table 更新
    func onRefresh(refreshControl: UIRefreshControl) {
        reload()
        refreshControl.endRefreshing()
    }

    // MARK: IBAction

    @IBAction func segmentControlChanged(sender: AnyObject) {
        reload()
    }
    
    @IBAction func returnFromDetail(segue: UIStoryboardSegue) {
        let hud : MBProgressHUD = MBProgressHUD .showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDModeText
        hud.labelText = "画像を削除しました"
        hud.hide(true, afterDelay: 3)
    }
    
    @IBAction func startBtnTouched(sender: AnyObject) {
        tableView.hidden = false
        startButton.hidden = true
        reload()
        
        photoFetcher.setFinishPhotoLoading()
    }
    
}
