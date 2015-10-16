//
//  AlarmViewController.swift
//  GoForIt
//
//  Created by 安部 裕介 on 9/20/14.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit

class AlarmViewController: UITableViewController, EditAlarmViewDelegate {
    var newTime: Dictionary<String, Int>!
    var data: NSMutableArray!
    var currentId: Int?
    
    override func viewDidLoad() {
        data = Alarm.sharedInstance.getAlarms()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addAlarm:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.newTime != nil && self.currentId != nil {
            Alarm.sharedInstance.editAlarm(id: self.currentId!, hour: self.newTime["hour"]!, minute: self.newTime["minute"]!)
            data = Alarm.sharedInstance.getAlarms()
            
            self.tableView.reloadData()
        }
        else if self.newTime != nil {
            Alarm.sharedInstance.setNewAlarm(hour: self.newTime["hour"]!, minute: self.newTime["minute"]!)
            data = Alarm.sharedInstance.getAlarms()
            
            self.tableView.reloadData()
        }
        self.newTime = nil
        self.currentId = nil
    }
    
    func addAlarm(sender: UIButton) {
        let controller = EditAlarmViewController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        let time = data.objectAtIndex(indexPath.row) as? NSMutableDictionary
        let hour = String(format: "%02d", time?.objectForKey("hour") as! Int)
        let minute = String(format: "%02d", time?.objectForKey("minute") as! Int)
        cell.textLabel?.text = "\(hour):\(minute)"
        cell.detailTextLabel?.text = "Alarm #\(indexPath.row)"
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            Alarm.sharedInstance.removeAlarmAtIndex(indexPath.row)
            data = Alarm.sharedInstance.getAlarms()
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = EditAlarmViewController()
        controller.delegate = self
        controller.id = indexPath.row
        self.presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}

