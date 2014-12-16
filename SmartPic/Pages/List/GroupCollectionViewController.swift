//
//  GroupCollectionViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/12/14.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

protocol GroupCollectionViewDelegate {
    func tapCell(groupInfo: GroupInfo)
    func emptyGroupInfoList()
}

class GroupCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var groupInfoList = [GroupInfo]()
    var delegate: GroupCollectionViewDelegate?
    private let photoFetcher = PhotoFetcher()
    private var cellInfoList: [NSDictionary] = []
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIRefreshControl
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    private func reload() {
        groupInfoList = photoFetcher.allPhotoGroupingByTime()
        println(groupInfoList)
        for (var i = 0; i < groupInfoList.count; i++) {
            let groupInfo: GroupInfo = groupInfoList[i]
            cellInfoList.append([
                "type": "date",
                "groupIndex": i,
                "assetIndex": -1
                ])
            for (var j = 0; j < groupInfo.assets.count; j++) {
                cellInfoList.append([
                    "type": "image",
                    "groupIndex": i,
                    "assetIndex": j
                    ])
            }
        }
        collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInfoList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellInfo: NSDictionary = cellInfoList[indexPath.row]
        let groupInfo: GroupInfo = groupInfoList[cellInfo["groupIndex"] as Int]
        if (cellInfo["type"] as String == "image") {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionImageCell", forIndexPath: indexPath) as CollectionImageCell
            let assetIndex: Int = cellInfo["assetIndex"] as Int
//            println(groupInfo)
//            println(assetIndex)
            let asset: PHAsset = groupInfo.assets[assetIndex]
            //let asset: PHAsset = groupInfoList[indexPath.row].assets[cellInfo["assetIndex"]] as PHAsset
            photoFetcher.requestImageForAsset(asset,
                size: cell.imageView.frame.size) { (image, info) -> Void in
                    cell.imageView.image = image
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionDateCell", forIndexPath: indexPath) as CollectionDateCell
            let dateDict = groupInfo.dateDictFromDate()
            cell.yearLabel.text = dateDict["year"]
            cell.dateLabel.text = dateDict["date"]
            cell.dayLabel.text = dateDict["day"]
            return cell
        }
    }
    
    
    // MARK: Private methods
    
    // プルダウンリフレッシュで table 更新
    func onRefresh(refreshControl: UIRefreshControl) {
        reload()
        refreshControl.endRefreshing()
    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    // MARK: UICollectionViewDataSource
//
//    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        //#warning Incomplete method implementation -- Return the number of sections
//        return 0
//    }
//
//
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //#warning Incomplete method implementation -- Return the number of items in the section
//        return 0
//    }
//
//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
//    
//        // Configure the cell
//    
//        return cell
//    }
//
//    // MARK: UICollectionViewDelegate
//
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
//        return false
//    }
//
//    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
//    
//    }
//    */

}
