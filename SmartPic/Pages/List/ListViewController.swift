//
//  ListViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/05.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class ListViewController: GAITrackedViewController, TutorialViewDelegate, PromoteViewDelegate, GroupTableViewDelegate {
    
    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var tutorialView: TutorialView!
    var noPictureView: NoPictureView!
    var latestDeletedCount: Int = 0
    private let photoFetcher = PhotoFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セグメントコントロールのローカライズ
        segmentedControl.setTitle(NSLocalizedString("Not Organized", comment:""), forSegmentAtIndex: 0)
        segmentedControl.setTitle(NSLocalizedString("All", comment:""), forSegmentAtIndex: 1)
        self.showContainerAtIndex(segmentedControl.selectedSegmentIndex)
        
        // Admob 設定
        bannerView.adSize = kGADAdSizeBanner
        bannerView.adUnitID = "ca-app-pub-2967292377011754/2952349221"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        
        
        if photoFetcher.isFinishPhotoLoading {
            self.checkAccessToPhotos()
        }
        else {
            // TODO
//            tableView.hidden = true
            
            // チュートリアル表示
            tutorialView = TutorialView(frame: self.view.frame)
            tutorialView.delegate = self
            self.view.addSubview(tutorialView)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "リストページ"
    }
    
//    private func reload() {
//        noPictureView?.removeFromSuperview()
//        if (segmentedControl.selectedSegmentIndex == 0) {
//            seriesList = photoFetcher.targetPhotoGroupingByTime()
//            if (seriesList.count == 0) {
//                // 整理対象ないよビュー表示
//                noPictureView = NoPictureView(frame: self.view.frame)
//                self.view.addSubview(noPictureView)
//                return
//            }
//        }
//        else {
//            seriesList = photoFetcher.allPhotoGroupingByTime()
//        }
//        tableView.reloadData()
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pushDetail" {
            let detailViewController:DetailViewController = segue.destinationViewController as DetailViewController
            detailViewController.groupInfo = sender as GroupInfo
            detailViewController.canKeepAll = (segmentedControl.selectedSegmentIndex == 0)
        }
        else if segue.identifier == "showStatus" {
            if sender is Bool {
                let nav = segue.destinationViewController as UINavigationController
                let statusViewController = nav.viewControllers.first as StatusViewController
                statusViewController.isShareMode = sender!.boolValue
            }
        } else if segue.identifier == "embedGroupTable" {
            let groupTableViewController: GroupTableViewController = segue.destinationViewController as GroupTableViewController
            groupTableViewController.delegate = self
        } else if segue.identifier == "embedGroupCollection" {
            let groupCollectionViewController: GroupCollectionViewController = segue.destinationViewController as GroupCollectionViewController
            //groupCollectionViewController.delegate = self
        }
    }
    
    func showContainerAtIndex(index: Int) {
        if (index == 0) {
            collectionContainer.hidden = true
            tableContainer.hidden = false
        } else if (index == 1) {
            tableContainer.hidden = true
            collectionContainer.hidden = false
        }
    }

    // MARK: IBAction

    @IBAction func segmentControlChanged(sender: AnyObject) {
        noPictureView?.removeFromSuperview()
        self.showContainerAtIndex(segmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func returnFromDetail(segue: UIStoryboardSegue) {
        let iOS81 = NSOperatingSystemVersion(majorVersion: 8, minorVersion: 1, patchVersion: 0)
        if NSProcessInfo().isOperatingSystemAtLeastVersion(iOS81) {
            showDeletedMessage()
        }
        else {
            var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showDeletedMessage", userInfo: nil, repeats: false)
        }
        
        // スコア表示
        let archivementManager = ArchivementManager.getInstance()
        let score = archivementManager.pointScoreIfArchive()
        if score != nil {
            println("score is \(score!)")
            PromoteView.showPromoteShareAlert(score!, delegate:self)
            archivementManager.saveArchiveActionDone(score!)
        }
        else {
            // レビュー表示
            let reviewManager = ReviewManager.getInstance()
            if reviewManager.shouldShowReviewAlert() {
                PromoteView.showPromoteReviewAlert()
            }
        }
        
        // 最初のセッションの場合
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.boolForKey("FirstSession") == true) {
            LocalPushManager().reset()
            AnalyticsManager().configureDeletedFirstSessionDimension()
        }
    }
    
    func showDeletedMessage() {
        let deletedCount: Int = latestDeletedCount
        
        let hud : MBProgressHUD = MBProgressHUD .showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDModeText
        if deletedCount != 0 {
            hud.labelText = String(format: NSLocalizedString("Deleted %d photos", comment:""), deletedCount)
        }
        else {
            hud.labelText = NSLocalizedString("Photos organized", comment:"")
        }
        hud.hide(true, afterDelay: 1)
    }
    
    func tapStartButton() {
        tutorialView.removeFromSuperview()
//        tableView.hidden = false
        
        photoFetcher.setFinishPhotoLoading()
        
        requestAccessToPhotos()
    }
    
    func tapCell(groupInfo: GroupInfo) {
        self.performSegueWithIdentifier("pushDetail", sender: groupInfo)
    }
    
    func emptyGroupInfoList() {
        noPictureView?.removeFromSuperview()
        noPictureView = NoPictureView(frame: self.view.frame)
        self.view.addSubview(noPictureView)
    }
    
    // MARK: PromoteViewDelegate
    
    func didTapShareStatusButton() {
        self.performSegueWithIdentifier("showStatus", sender: true)
    }
    
    
    // MARK: Check Access Photos
    
    private func requestAccessToPhotos() {
        PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
            switch(status) {
            case PHAuthorizationStatus.NotDetermined:
                // まだ権限選択してない
                println("do nothing")
                
            case .Restricted:
                // ペアレンタルコントロールなどでアクセス制限されてる
                self.showErrorMessageWithoutMove()
                
            case .Denied:
                // 拒否されてる
                self.showErrorMessageWithMoveSettingApp()
                
            case .Authorized:
                // 許可されてる
                dispatch_async(dispatch_get_main_queue(), {
//                    self.reload()
//                    AnalyticsManager().configureCountsDimension(self.seriesList)
                })
                
                // ローカルプッシュ登録
                LocalPushManager().registerAll()
            }
        }
    }
    
    private func checkAccessToPhotos() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch(status) {
        case PHAuthorizationStatus.NotDetermined:
            // まだ権限選択してない
            self.requestAccessToPhotos()    // 権限をリクエスト
            
        case .Restricted:
            // ペアレンタルコントロールなどでアクセス制限されてる
            self.showErrorMessageWithoutMove()

        case .Denied:
            // 拒否されてる
            self.showErrorMessageWithMoveSettingApp()

        case .Authorized:
            // 許可されてる
            // TODO
            println()
//            self.reload()
//            AnalyticsManager().configureCountsDimension(seriesList)
        }
    }
    
    // 権限が制約されてる場合は注意の文言を出す
    private func showErrorMessageWithoutMove() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment:""),
            message: NSLocalizedString("ERROR_MESSAGE_WITHOUT_MOVE", comment:""),
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // 権限が足りない場合は設定画面へ飛ばす
    private func showErrorMessageWithMoveSettingApp() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment:""),
            message: NSLocalizedString("ERROR_MESSAGE_WITH_MOVE", comment:""),
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:""), style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("To Settings.", comment:""), style: .Default, handler: { (action) -> Void in
            // 設定画面へ遷移する
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(url!)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
}
