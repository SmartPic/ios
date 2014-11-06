//
//  ListCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/05.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class ListCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var contentWrapperView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    var maxDisplayedPictureLength = 4
    
    var series: [PHAsset] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var groupInfo: GroupInfo = GroupInfo() {
        didSet {
            self.series = groupInfo.assets
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if (highlighted) {
            wrapperView.backgroundColor = UIColor.colorWithRGBHex(0xc1c3c3, alpha: 1.0)
        } else {
            wrapperView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let borderWidth : CGFloat = 392// 320 + 68 + 4
        if (UIScreen.mainScreen().bounds.width > borderWidth) {
            collectionViewWidth.constant = borderWidth
            maxDisplayedPictureLength = 5
        }
        
        collectionView.scrollsToTop = false
        contentWrapperView.layer.cornerRadius = 5
        contentWrapperView.clipsToBounds = true
        contentWrapperView.layer.masksToBounds = false
        contentWrapperView.layer.shadowOffset = CGSizeMake(0, 1)
        contentWrapperView.layer.shadowOpacity = 0.2
        contentWrapperView.layer.shadowColor = UIColor.blackColor().CGColor
        contentWrapperView.layer.shadowRadius = 0.0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ListImageCell = collectionView.dequeueReusableCellWithReuseIdentifier(ListImageCell.className, forIndexPath: indexPath) as ListImageCell
        
        cell.listImageView.image = nil
        if (indexPath.row == maxDisplayedPictureLength - 1 && series.count > maxDisplayedPictureLength) {
            cell.moreView.hidden = false
            cell.numberLabel.text = "+" + (String)(series.count - maxDisplayedPictureLength)
        } else {
            cell.moreView.hidden = true
        }
        
        var asset: PHAsset = series[indexPath.row]
        var photoFetcher = PhotoFetcher()
        photoFetcher.requestImageForAsset(asset,
            size: cell.listImageView.frame.size) { (image, info) -> Void in
                cell.listImageView.image = image
        }
        
        return cell
    }
}
