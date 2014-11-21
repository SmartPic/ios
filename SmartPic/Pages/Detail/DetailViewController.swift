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
    @IBOutlet weak var saveButton: FlatButton!
    @IBOutlet weak var leftButton: FlatButton!

    @IBOutlet weak var leftEdgeConst: NSLayoutConstraint!
    
    var groupInfo: GroupInfo = GroupInfo() {
        didSet {
            self.pictures = groupInfo.assets
        }
    }
    var pictures: [PHAsset] = []
    var canKeepAll = true
    
    private var pictureIndex: Int = 0
    
    var pickedPictureIndexes: [Int] = []
    
    let photoFetcher = PhotoFetcher()

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.setTitle(NSLocalizedString("Delete All", comment:""), forState: .Normal)
        leftButton.setTitle(NSLocalizedString("Left All", comment:""), forState: .Normal)
        
        leftButton.setTitleColor(UIColor.colorWithRGBHex(0x4d4949), forState: .Normal)
        leftButton.normalColor = UIColor.whiteColor()
        leftButton.highlightedColor = UIColor.colorWithRGBHex(0xdedede)
        leftButton.layer.borderColor = UIColor.colorWithRGBHex(0xe3d42e).CGColor
        leftButton.layer.borderWidth = 2.0
        
        // imageview settings
        setUpImageView()
        
        // 中央画像の挿入
        bigImageView.contentMode = .ScaleAspectFit
        var asset: PHAsset = pictures[pictureIndex]
        photoFetcher.requestImageForAsset(asset,
            size: bigImageView.frame.size) { (image, info) -> Void in
                if (image === nil) { return }
                self.bigImageView.image = image
        }
        
        if !canKeepAll {
            self.leftButton.hidden = true
            self.leftEdgeConst.priority = 800
        }
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "詳細ページ"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.selectItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: nil)
    }
    
    private func setUpImageView() {
        let toLeftGesture = UISwipeGestureRecognizer(target: self, action: "swipeToLeft")
        toLeftGesture.direction = .Left
        bigImageView.addGestureRecognizer(toLeftGesture)
        
        let toRightGesture = UISwipeGestureRecognizer(target: self, action: "swipeToRight")
        toRightGesture.direction = .Right
        bigImageView.addGestureRecognizer(toRightGesture)
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
        pictureIndex = indexPath.row
        photoFetcher.requestImageForAsset(asset,
            size: bigImageView.frame.size) { (image, info) -> Void in
                if (image === nil) { return }
                self.bigImageView.image = image
        }
        
        scrollForSelectedViewToCenter()
    }
    
    // MARK: - IBAction
    // 整理するボタン押下時
    @IBAction func tapSaveButton(sender: AnyObject) {
        deleteUnPickerPictures()
    }
    
    // 残すボタン押下時
    @IBAction func tapLeftButton(sender: AnyObject) {
        leftAllPictures()
    }

    
    @IBAction func tapPickButton(sender: AnyObject) {
        pickButton.selected = !pickButton.selected
        
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
            
            UIView.animateWithDuration(0.2,
                delay: 0,
                options: .CurveEaseIn,
                animations: { () -> Void in
                    self.saveButton.setTitle(NSLocalizedString("Delete all except marked photos", comment:""), forState: UIControlState.Normal)
                    self.leftButton.alpha = 0.0
                    self.leftEdgeConst.priority = 800
                    
                    self.view.layoutIfNeeded()
            }, completion: nil)

        } else {
            
            UIView.animateWithDuration(0.2, delay: 0,
                options: .CurveEaseOut,
                animations: { () -> Void in
                    self.saveButton.setTitle(NSLocalizedString("Delete All", comment:""), forState: UIControlState.Normal)
                    self.leftButton.alpha = self.canKeepAll ? 1 : 0
                    self.leftEdgeConst.priority = self.canKeepAll ? 250 : 800
                    
                    self.view.layoutIfNeeded()
            }, completion: nil)

        }
    }
    
    
    
    // MARK: Action ( UIGesture )
    
    func swipeToLeft() {
        if pictureIndex < pictures.count - 1 {
            pictureIndex++
            updateSelectedForPictureIndex()
        }
    }
    
    func swipeToRight() {
        if 0 < pictureIndex {
            pictureIndex--
            updateSelectedForPictureIndex()
        }
    }
    
    private func updateSelectedForPictureIndex() {
        // bigimageを変更
        var asset: PHAsset = pictures[pictureIndex]
        photoFetcher.requestImageForAsset(asset,
            size: bigImageView.frame.size) { (image, info) -> Void in
                if (image === nil) { return }
                self.bigImageView.image = image
        }
        
        // 選択状態にする
        collectionView.selectItemAtIndexPath(NSIndexPath(forRow: pictureIndex, inSection: 0),
            animated: false,
            scrollPosition: nil)
        
        // 選択したcellが中央に来るようにスクロール
        scrollForSelectedViewToCenter()
        
        // 選択したcellの選択状態を取得して反映
        let indexPaths : [NSIndexPath] = collectionView.indexPathsForSelectedItems() as [NSIndexPath]
        let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
        let visibleIndexPaths: [NSIndexPath] = self.collectionView.indexPathsForVisibleItems() as [NSIndexPath]
        if contains(visibleIndexPaths, indexPath) {
            let cell: DetailImageCell = collectionView.cellForItemAtIndexPath(indexPath) as DetailImageCell
            cell.isPicked = contains(pickedPictureIndexes, indexPath.row)
            pickButton.selected = cell.isPicked
        }
    }
    
    private func scrollForSelectedViewToCenter() {
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: pictureIndex, inSection: 0),
            atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally,
            animated: true)
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
    
    func leftAllPictures() {
        let delManager = DeleteManager.getInstance()
        delManager.saveDeletedAssets([], arrangedAssets: self.pictures)
        
        dispatch_async(dispatch_get_main_queue(), {
            // 解決法
            // http://stackoverflow.com/questions/24296023/animatewithdurationanimationscompletion-in-swift/24297018#24297018
            _ in self.performSegueWithIdentifier("unwindDetail", sender: 0); return ()
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
