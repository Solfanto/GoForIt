//
//  Alarm.swift
//  GoForIt
//
//  Created by Lidner on 14/9/20.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit

private let _alarmInstance = Alarm()
class Alarm {
    class var sharedInstance: Alarm {
        return _alarmInstance
    }
    
    func getAlarms() -> NSMutableArray {
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms")?.mutableCopy() as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
        }
        return alarmsArray!
    }
    
    func setNewAlarm(hour hour: NSNumber, minute: NSNumber) {
        let newElement: NSDictionary = [
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
        alarmsArray?.addObject(newElement)
        
        NSUserDefaults.standardUserDefaults().setValue(alarmsArray, forKey: "alarms")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func removeAlarmAtIndex(index: Int) {
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms")?.mutableCopy() as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
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
