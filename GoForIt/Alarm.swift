//
//  Alarm.swift
//  GoForIt
//
//  Created by Lidner on 14/9/20.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit

class Alarm {
    
    static let sharedInstance = Alarm()
    
    func getAlarms() -> NSMutableArray {
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms")?.mutableCopy() as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
        }
        return alarmsArray!
    }
    
    func setNewAlarm(id id: Int? = nil, hour: NSNumber, minute: NSNumber) {
        let newElement: NSDictionary = [
            "id": "\(NSDate())",
            "hour": hour,
            "minute": minute
        ]
        
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms")?.mutableCopy() as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
        }
        else {
            alarmsArray = NSMutableArray(array: alarmsArray!)
        }
        if id != nil {
            alarmsArray?.insertObject(newElement, atIndex: id!)
        }
        else {
            alarmsArray?.addObject(newElement)
        }
        
        NSUserDefaults.standardUserDefaults().setValue(alarmsArray, forKey: "alarms")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        
        // set components for time 7:00 a.m.
        
        let componentsForFireDate = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
        
        componentsForFireDate.hour = hour as Int
        componentsForFireDate.minute = minute as Int
        componentsForFireDate.second = 0
        
        let fireDateOfNotification = calendar.dateFromComponents(componentsForFireDate)
        
        // Create the notification
        
        let notification = UILocalNotification()
        
        notification.fireDate = fireDateOfNotification
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.alertBody = "Cheer up!"
        notification.alertAction = "Listen"
        notification.userInfo = ["id": "\(NSDate())"]
        notification.repeatInterval = .Day
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 1
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func editAlarm(id id: Int, hour: NSNumber, minute: NSNumber) {
        removeAlarmAtIndex(id)
        setNewAlarm(id: id, hour: hour, minute: minute)
    }
    
    func removeAlarmAtIndex(index: Int) {
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms")?.mutableCopy() as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
        }
        
        let app = UIApplication.sharedApplication()
        let uidtodelete = alarmsArray![index]["id"] as! String
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            let userInfoCurrent = notification.userInfo as! [String:AnyObject]
            let uid = userInfoCurrent["id"] as! String
            if alarmsArray?.count <= 1 {
                app.cancelLocalNotification(notification)
            }
            else if uid == uidtodelete {
                //Cancelling local notification
                app.cancelLocalNotification(notification)
                break
            }
        }
        
        alarmsArray?.removeObjectAtIndex(index)
        NSUserDefaults.standardUserDefaults().setValue(alarmsArray, forKey: "alarms")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func moveAlarmFromIndex(fromIndex: Int, toIndex: Int) {
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms")?.mutableCopy() as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
        }
        
        let object: AnyObject? = alarmsArray?.objectAtIndex(fromIndex)
        alarmsArray?.removeObjectAtIndex(fromIndex)
        alarmsArray?.insertObject(object!, atIndex: toIndex)
        
        NSUserDefaults.standardUserDefaults().setValue(alarmsArray, forKey: "alarms")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func resetAllAlarms() {
        NSUserDefaults.standardUserDefaults().setValue(NSMutableArray(), forKey: "alarms")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
