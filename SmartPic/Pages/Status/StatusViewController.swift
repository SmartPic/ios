//
//  StatusViewController.swift
//  SmartPic
//
//  Created by himara2 on 2014/11/22.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Social

class StatusViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let deleteManager = DeleteManager.getInstance()
    
    var isShareMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.layoutMargins = UIEdgeInsetsZero

        // シェアモードならいきなりShareシートを表示
        if isShareMode {
            showShareSheet()
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "効果ページ"
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        
        var cellIdentifier = ""
        switch indexPath.row {
        case 0:
            cellIdentifier = "PhotoCountCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as StatusCountCell
            cell.countLabel.text = String(deleteManager.deleteAssetIds.count)
            cell.countLabel.sizeToFit()
            return cell
        case 1:
            cellIdentifier = "PhotoSizeCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as StatusSizeCell
            cell.sizeLabel.text = deleteManager.deleteAssetFileSize.format("%.1f")
            cell.sizeLabel.sizeToFit()
            return cell
        case 2:
            cellIdentifier = "ExampleMusicCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as StatusMusicCell
            println("music is \(deleteManager.deleteAssetFileSize / 5)")
            cell.musicLabel.text = String(Int(deleteManager.deleteAssetFileSize / 5))
            cell.musicLabel.sizeToFit()
            return cell
        default:
            cellIdentifier = ""
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        return cell
    }
    
    
    private func showShareSheet() {
        let alert = UIAlertController(title: "ALPACAスコアをシェアする",
            message: "ALPACAで削除した成果をシェアしよう", preferredStyle: .ActionSheet)
        
        // Twitter
        alert.addAction(UIAlertAction(title: "Twitterにシェア",
            style: .Default,
            handler: { (action) -> Void in
                self.shareTwitter()
        }))
        
        // Facebook
        alert.addAction(UIAlertAction(title: "Facebookにシェア",
            style: .Default,
            handler: { (action) -> Void in
                self.shareFacebook()
        }))
        
        // Cancel
        alert.addAction(UIAlertAction(title: "キャンセル",
            style: .Cancel,
            handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    private func captureStatusView() -> UIImage {
        let size = CGSizeMake(tableView.frame.size.width, 168 * 3)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let tableOffset = tableView.contentOffset
        tableView.contentOffset = CGPointMake(0, 0)
        
        let context = UIGraphicsGetCurrentContext()
        let point = self.view.frame.origin
        let affineMoveLeftTop: CGAffineTransform = CGAffineTransformMakeTranslation(-point.x, -point.y)
        CGContextConcatCTM(context, affineMoveLeftTop)
        
        // viewから画像を切り取る
        self.view.layer.renderInContext(context)
        
        // UIImage として取得
        let cnvImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        tableView.contentOffset = tableOffset

        return cnvImg
    }
    
    
    // MARK: - Share SNS
    
    private func composeViewController(serviceType: String) -> SLComposeViewController {
        
        let count = deleteManager.deleteAssetIds.count
        let size = deleteManager.deleteAssetFileSize.format("%.1f")
        
        let vc = SLComposeViewController(forServiceType: serviceType)
        vc.setInitialText("ALPACAで\(count)枚の写真を削除し、\(size)MBの空き容量を獲得しました！ #ALPACA")
        vc.addImage(captureStatusView())
        vc.addURL(NSURL(string: kAppStoreUrl))
        
        return vc
    }
    
    private func shareTwitter() {
        let vc = composeViewController(SLServiceTypeTwitter)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    private func shareFacebook() {
        let vc = composeViewController(SLServiceTypeFacebook)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - IBAction
    
    @IBAction func closeBtnTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionBtnTouched(sender: AnyObject) {
        showShareSheet()
    }
    

}
