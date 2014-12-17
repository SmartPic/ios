//
//  GroupTableViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/12/14.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

protocol GroupTableViewDelegate {
    func tapGroup(groupInfo: GroupInfo, title: String)
    func emptyGroupInfoList()
}

class GroupTableViewController: UITableViewController {

    // MARK: Properties

    var delegate: GroupTableViewDelegate?
    private var groupInfoList = [GroupInfo]()
    private let photoFetcher = PhotoFetcher()
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIRefreshControl
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        reload()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: UITableView delegate, datasourse
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupInfoList.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ListCell = tableView.dequeueReusableCellWithIdentifier(ListCell.className) as ListCell
        
        let group = groupInfoList[indexPath.row]
        
        cell.addressLabel.text = nil
        group.loadAddressStr { (address, error) -> Void in
            if error != nil {
                cell.addressLabel.text = nil
            }
            else {
                cell.addressLabel.text = address
            }
        }
        cell.dateLabel.text = group.dateStrFromDate()
        cell.groupInfo = group
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let groupInfo: GroupInfo = groupInfoList[indexPath.row]
        delegate?.tapGroup(groupInfo, title: "")
    }
    
    
    // MARK: Private methods
    
    func reload() {
        groupInfoList = photoFetcher.targetPhotoGroupingByTime()
        if (groupInfoList.count == 0) {
            // 整理対象ないよビュー表示
            delegate?.emptyGroupInfoList()
        }
        tableView.reloadData()
    }
    
    func sendLog() {
        AnalyticsManager().configureCountsDimension(groupInfoList)
    }
    
    // プルダウンリフレッシュで table 更新
    func onRefresh(refreshControl: UIRefreshControl) {
        reload()
        refreshControl.endRefreshing()
    }
}
