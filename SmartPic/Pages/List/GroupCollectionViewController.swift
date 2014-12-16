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

class GroupCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    var groupInfoList = [GroupInfo]()
    var delegate: GroupCollectionViewDelegate?
    private let photoFetcher = PhotoFetcher()
    private var cellInfoList: [NSDictionary] = []
    private var cellSize: CGSize = CGSizeMake(77, 77)
    private var cellMinPadding: Float = 4
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = DeviceUtil().iOSDevice()
        if (device == "iPhone6") {
            cellSize = CGSizeMake(71, 71)
        } else if (device == "iPhone6 Plus") {
            cellSize = CGSizeMake(78, 78)
        }
        
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
            let asset: PHAsset = groupInfo.assets[assetIndex]
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    
    // MARK: Private methods
    
    // プルダウンリフレッシュで table 更新
    func onRefresh(refreshControl: UIRefreshControl) {
        reload()
        refreshControl.endRefreshing()
    }
}
