//
//  ListViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/05.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var seriesList: [[PHAsset]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // TODO: アルバムから取得してセット
//        let image11:UIImage = UIImage(named:"11.jpg")
//        let image12:UIImage = UIImage(named:"12.jpg")
//        let image13:UIImage = UIImage(named:"13.jpg")
//        let image14:UIImage = UIImage(named:"14.jpg")
//        let image15:UIImage = UIImage(named:"15.jpg")
//        let image21:UIImage = UIImage(named:"21.jpg")
//        let image22:UIImage = UIImage(named:"22.jpg")
//        let image23:UIImage = UIImage(named:"23.jpg")
//        seriesList = [
//            [image11, image12, image13, image14, image15],
//            [image21, image22, image23]
//        ]
        
        var photoFetcher = PhotoFetcher()
        seriesList = photoFetcher.photosTimeImmediately()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seriesList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO 動的に高さ計算して返す
        return 80;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ListCell = tableView.dequeueReusableCellWithIdentifier(ListCell.className) as ListCell
        cell.series = seriesList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushDetail", sender: nil)
    }

}
