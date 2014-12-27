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
    func tapGroup(groupInfo: GroupInfo, title: String)
    func tapImage(asset: PHAsset)
}

class GroupCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    var delegate: GroupCollectionViewDelegate?
    private var groupInfoList = [GroupInfo]()
    private let photoFetcher = PhotoFetcher()
    private var cellInfoList: [NSDictionary] = []
    private var cellSize: CGSize = CGSizeMake(77, 77)
    private var cellMinPadding: CGFloat = 4
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = UIDevice().segmentName()
        if (device == "iPhone6") {
            cellSize = CGSizeMake(71, 71)
            cellMinPadding = 5
        } else if (device == "iPhone6 Plus") {
            cellSize = CGSizeMake(78, 78)
            cellMinPadding = 6
        }
        
        // UIRefreshControl
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
        reload()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func reload() {
        groupInfoList = photoFetcher.allPhotoGroupingByTime()
        cellInfoList = []
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
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInfoList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellInfo: Dictionary = cellInfoList[indexPath.row]
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellInfo: Dictionary = cellInfoList[indexPath.row]
        let groupInfo: GroupInfo = groupInfoList[cellInfo["groupIndex"] as Int]
        if (cellInfo["type"] as String == "image") {
            let asset: PHAsset = groupInfo.assets[cellInfo["assetIndex"] as Int]
            delegate?.tapImage(asset)
        } else if (cellInfo["type"] as String == "date") {
            delegate?.tapGroup(groupInfo, title:groupInfo.dateStrFromDate())
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMinPadding
    }
    
    // MARK: Private methods
    
    // プルダウンリフレッシュで table 更新
    func onRefresh(refreshControl: UIRefreshControl) {
        reload()
        refreshControl.endRefreshing()
    }
}
