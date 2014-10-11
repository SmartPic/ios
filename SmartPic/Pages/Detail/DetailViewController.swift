//
//  DetailViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DetailImageCellDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pictures: [PHAsset] = []
    var pickedPictureIndexes: [Int] = []

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigImageView.contentMode = .ScaleAspectFit
        var asset: PHAsset = pictures[0]
        var photoFetcher = PhotoFetcher()
        photoFetcher.requestImageForAsset(asset,
            size: bigImageView.frame.size) { (image, info) -> Void in
                self.bigImageView.image = image
        }
    }

    // MARK: - CollectionView methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var asset: PHAsset = pictures[indexPath.row]
        let imageHeight = 80 // TODO: Cell から取得
        let imageWidth = imageHeight * asset.pixelWidth / asset.pixelHeight
        let imageSize: CGSize = CGSizeMake(CGFloat(imageWidth), 120.0)
        return imageSize
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: DetailImageCell = collectionView.dequeueReusableCellWithReuseIdentifier(DetailImageCell.className, forIndexPath: indexPath) as DetailImageCell
        
        cell.pickButton.hidden = !cell.selected
        cell.unpickButton.hidden = !cell.selected
        cell.delegate = self
        cell.imageView.image = nil
        
        var asset: PHAsset = pictures[indexPath.row]
        var photoFetcher = PhotoFetcher()
        photoFetcher.requestImageForAsset(asset,
            size: cell.imageView.frame.size) { (image, info) -> Void in
                cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell: DetailImageCell = collectionView.cellForItemAtIndexPath(indexPath) as DetailImageCell
        cell.pickButton.hidden = false
        cell.unpickButton.hidden = false
        
        var asset: PHAsset = pictures[indexPath.row]
        var photoFetcher = PhotoFetcher()
        photoFetcher.requestImageForAsset(asset,
            size: bigImageView.frame.size) { (image, info) -> Void in
                self.bigImageView.image = image
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: DetailImageCell = collectionView.cellForItemAtIndexPath(indexPath) as DetailImageCell
        cell.pickButton.hidden = true
        cell.unpickButton.hidden = true
    }
    
    // MARK: - IBAction
    // 整理するボタン押下時
    @IBAction func tapSaveButton(sender: AnyObject) {
        println(pickedPictureIndexes) // TODO: こいつは残す
        // TODO 他は消す
    }
    
    // MARK: - DetailImageCellDelegate
    func tapPickButton() {
        let indexPaths: [NSIndexPath] = collectionView.indexPathsForSelectedItems() as [NSIndexPath]
        let indexPath: NSIndexPath = indexPaths[0]
        pickedPictureIndexes.append(indexPath.row)
    }
    
    func tapUnpickButton() {
        let indexPaths: [NSIndexPath] = collectionView.indexPathsForSelectedItems() as [NSIndexPath]
        let indexPath: NSIndexPath = indexPaths[0]
        let row = indexPath.row
        var removeIndex = 0
        for (var i = 0; i < pickedPictureIndexes.count; i++) {
            if (pickedPictureIndexes[i] == row) {
                removeIndex = i
            }
        }
        pickedPictureIndexes.removeAtIndex(removeIndex)
    }
}
