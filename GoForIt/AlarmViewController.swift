//
//  AlarmViewController.swift
//  GoForIt
//
//  Created by 安部 裕介 on 9/20/14.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit

class AlarmViewController: UITableViewController, UITableViewDataSource, EditAlarmViewDelegate {
    var newTime: Dictionary<String, Int>!
    override func viewDidLoad() {
        self.tableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "onClickMyButton:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.newTime != nil {
            Alarm.sharedInstance.setNewAlarm(hour: self.newTime["hour"]!, minute: self.newTime["minute"]!, index: 0)

        }
        
    }
    
    func onClickMyButton(sender: UIButton) {
        var next = EditAlarmViewController()
        next.delegate = self
        let navigationController = UINavigationController(rootViewController: next)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Alarm.sharedInstance.getAlarms().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        let time = Alarm.sharedInstance.getAlarms().objectAtIndex(indexPath.row) as? NSMutableDictionary
        let hour = time?.objectForKey("hour") as NSNumber
        let minute = time?.objectForKey("minute") as NSNumber
        cell.textLabel?.text = "\(hour):\(minute)"
        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        return cell
    }
    
    
    
}

