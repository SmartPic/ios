//
//  DetailViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: GAITrackedViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var groupInfo: GroupInfo = GroupInfo() {
        didSet {
            self.pictures = groupInfo.assets
        }
    }
    var pictures: [PHAsset] = []
    var pickedPictureIndexes: [Int] = []
    
    let photoFetcher = PhotoFetcher()

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // saveButton settings
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowOffset = CGSizeMake(0, 1)
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowColor = UIColor.blackColor().CGColor
        saveButton.layer.shadowRadius = 0.0
        saveButton.backgroundColor = UIColor.colorWithRGBHex(0xe3d42e)
        saveButton.setTitle(NSLocalizedString("Delete All", comment:""), forState: UIControlState.Normal)
        
        // 中央画像の挿入
        bigImageView.contentMode = .ScaleAspectFit
        var asset: PHAsset = pictures[0]
        photoFetcher.requestImageForAsset(asset,
            size: bigImageView.frame.size) { (image, info) -> Void in
                if (image === nil) { return }
                self.bigImageView.image = image
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "詳細ページ"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.selectItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: nil)
    }

    // MARK: - CollectionView methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: DetailImageCell = collectionView.dequeueReusableCellWithReuseIdentifier(DetailImageCell.className, forIndexPath: indexPath) as DetailImageCell
        
        cell.imageView.image = nil
        cell.myIndex = indexPath.row
        cell.isPicked = contains(pickedPictureIndexes, indexPath.row)
        cell.staredMaskImageView.hidden = !cell.isPicked
        
        var asset: PHAsset = pictures[indexPath.row]
        photoFetcher.requestImageForAsset(asset,
            size: cell.imageView.frame.size) { (image, info) -> Void in
                cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: DetailImageCell = collectionView.cellForItemAtIndexPath(indexPath) as DetailImageCell
        pickButton.selected = cell.isPicked
        
        var asset: PHAsset = pictures[indexPath.row]
        photoFetcher.requestImageForAsset(asset,
            size: bigImageView.frame.size) { (image, info) -> Void in
                if (image === nil) { return }
                self.bigImageView.image = image
        }
    }
    
    // MARK: - IBAction
    // 整理するボタン押下時
    @IBAction func tapSaveButton(sender: AnyObject) {
        deleteUnPickerPictures()
    }
    
    @IBAction func tapPickButton(sender: AnyObject) {
        pickButton.selected = !pickButton.selected
        
        collectionView.indexPathsForVisibleItems()
        let indexPaths : [NSIndexPath] = collectionView.indexPathsForSelectedItems() as [NSIndexPath]
        let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
        let visibleIndexPaths: [NSIndexPath] = self.collectionView.indexPathsForVisibleItems() as [NSIndexPath]
        if contains(visibleIndexPaths, indexPath) {
            let cell: DetailImageCell = collectionView.cellForItemAtIndexPath(indexPath) as DetailImageCell
            cell.isPicked = pickButton.selected
        }
        
        if (pickButton.selected) {
            self.pushToPickedPictureIndexes(indexPath.row)
        } else {
            self.removeFromPickedPictureIndexes(indexPath.row)
        }
        
        if (pickedPictureIndexes.count > 0) {
            saveButton.setTitle(NSLocalizedString("Delete all except marked photos", comment:""), forState: UIControlState.Normal)
        } else {
            saveButton.setTitle(NSLocalizedString("Delete All", comment:""), forState: UIControlState.Normal)
        }
    }
    
    // MARK: - 独自メソッド群
    func deleteUnPickerPictures() {
        var delTargetAssets = [PHAsset]()
        for (index, asset) in enumerate(pictures) {
            if !contains(pickedPictureIndexes, index) {
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
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("ui_action", action: "delete image", label: "", value: delCount).build())
                        
                        println("delete success!")
                        
                        // 削除した画像のID、残した画像のIDを記憶しておく
                        let delManager = DeleteManager.getInstance()
                        delManager.saveDeletedAssets(delTargetAssets, arrangedAssets: self.pictures)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            // 解決法
                            // http://stackoverflow.com/questions/24296023/animatewithdurationanimationscompletion-in-swift/24297018#24297018
                            _ in self.performSegueWithIdentifier("unwindDetail", sender: delCount); return ()
                        })
                    }
                    else {
                        println("delete failed..")
                    }
                }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "unwindDetail") {
            let listViewController:ListViewController = segue.destinationViewController as ListViewController
            listViewController.latestDeletedCount = sender as Int
        }
    }
    
    func pushToPickedPictureIndexes(pickedIndex: Int) {
        pickedPictureIndexes.append(pickedIndex)
    }
    
    func removeFromPickedPictureIndexes(unpickedIndex: Int) {
        var removeIndex = -1
        for (var i = 0; i < pickedPictureIndexes.count; i++) {
            if (pickedPictureIndexes[i] == unpickedIndex) {
                removeIndex = i
            }
        }
        if (removeIndex != -1) {
            pickedPictureIndexes.removeAtIndex(removeIndex)
        }
    }
}
