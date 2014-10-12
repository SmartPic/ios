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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ListImageCell = collectionView.dequeueReusableCellWithReuseIdentifier(ListImageCell.className, forIndexPath: indexPath) as ListImageCell
        
        cell.listImageView.image = nil
        
        var asset: PHAsset = series[indexPath.row]
        var photoFetcher = PhotoFetcher()
        photoFetcher.requestImageForAsset(asset,
            size: cell.listImageView.frame.size) { (image, info) -> Void in
                cell.listImageView.image = image
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var asset: PHAsset = series[indexPath.row]
        let imageHeight = 60 // TODO: Cell から取得
        let imageWidth = imageHeight * asset.pixelWidth / asset.pixelHeight
        let imageSize: CGSize = CGSizeMake(CGFloat(imageWidth), CGFloat(imageHeight))
        return imageSize
    }
}
