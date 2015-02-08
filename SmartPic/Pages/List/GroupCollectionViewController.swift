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
    
    func doneEditMode()
}

class GroupCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    var delegate: GroupCollectionViewDelegate?
    private var groupInfoList = [GroupInfo]()
    private let photoFetcher = PhotoFetcher()
    private var cellInfoList: [NSDictionary] = []
    private var cellSize: CGSize = CGSizeMake(77, 77)
    private var cellMinPadding: CGFloat = 4
    
    var pageName: String = "multi selected"// "serially group" or "date group"
    
    private var isEditMode = false
    private var selectedIndexPathes = [NSIndexPath]()
    
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
            
            // 選択中のcellは色をつける
            if find(selectedIndexPathes, indexPath) != nil {
                cell.isSelected = true
            }
            else {
                cell.isSelected = false
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

        if !isEditMode {
            let cellInfo: Dictionary = cellInfoList[indexPath.row]
            let groupInfo: GroupInfo = groupInfoList[cellInfo["groupIndex"] as Int]
            if (cellInfo["type"] as String == "image") {
                let asset: PHAsset = groupInfo.assets[cellInfo["assetIndex"] as Int]
                delegate?.tapImage(asset)
            } else if (cellInfo["type"] as String == "date") {
                delegate?.tapGroup(groupInfo, title:groupInfo.dateStrFromDate())
            }
        }
        else {
            let cellInfo: Dictionary = cellInfoList[indexPath.row]
            let groupInfo: GroupInfo = groupInfoList[cellInfo["groupIndex"] as Int]
            
            // 日付セルの場合は何もしない
            if cellInfo["type"] as String == "date" {
                return
            }
            
            let index = find(selectedIndexPathes, indexPath)
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as CollectionImageCell
            if index == nil {
                selectedIndexPathes.append(indexPath)
                cell.isSelected = true
            }
            else {
                selectedIndexPathes.removeAtIndex(index!)
                cell.isSelected = false
            }
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMinPadding
    }
    
    
    func startEditMode() {
        isEditMode = true
    }
    
    func doneEditMode() {
        isEditMode = false
        selectedIndexPathes = []
        collectionView.reloadData()
    }
    
    func submitDeletion() {
        var delTargetAssets = [PHAsset]()
        
        for indexPath in selectedIndexPathes {
            let cellInfo: Dictionary = cellInfoList[indexPath.row]
            let groupInfo: GroupInfo = groupInfoList[cellInfo["groupIndex"] as Int]
            if (cellInfo["type"] as String == "image") {
                let asset: PHAsset = groupInfo.assets[cellInfo["assetIndex"] as Int]
                delTargetAssets.append(asset)
            }
        }
        
        var delCount: Int = delTargetAssets.count
        photoFetcher.deleteImageAssets(delTargetAssets,
            completionHandler: { (success, error) -> Void in
                if error != nil {
                    println("error occured. error is \(error!)")
                }
                else {
                    if success {
                        let tracker = GAI.sharedInstance().defaultTracker;
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("ui_action", action: "delete image", label: self.pageName, value: delCount).build())
                        
                        println("delete success!")
                        
                        // 削除した画像のID、残した画像のIDを記憶しておく
                        let delManager = DeleteManager.getInstance()
                        delManager.saveDeletedAssets(delTargetAssets, arrangedAssets: [])
                        
                        // レビューアラート用の表示
                        let reviewManager = ReviewManager.getInstance()
                        reviewManager.incrementDeleteCount()
                        
                        // 更新
                        dispatch_async(dispatch_get_main_queue(), {
                            self.reload()
                        })

                    }
                    else {
                        println("delete failed..")
                    }
                }
        })
        
        // 編集モード完了
        delegate?.doneEditMode()
    }
    
    // MARK: Private methods
    
    // プルダウンリフレッシュで table 更新
    func onRefresh(refreshControl: UIRefreshControl) {
        reload()
        refreshControl.endRefreshing()
    }
    
}
