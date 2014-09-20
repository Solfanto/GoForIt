//
//  AlarmViewController.swift
//  GoForIt
//
//  Created by 安部 裕介 on 9/20/14.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit

class AlarmViewController: UITableViewController, UITableViewDataSource, NextViewDelegate {
    var newTime: NSDate?
    override func viewDidLoad() {
        self.tableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "onClickMyButton:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("\(self.newTime)")
    }
    func onClickMyButton(sender: UIButton) {
        var next = NextViewController()
        next.delegate = self
        let navigationController = UINavigationController(rootViewController: next)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel?.text = "Row #\(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        return cell
    }
    
    
    
}

