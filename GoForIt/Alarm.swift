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
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms") as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
        }
        return alarmsArray!
    }
    
    func setNewAlarm(#hour: NSNumber, minute: NSNumber, index: NSNumber) {
        let newElement: NSDictionary = [
            "hour": hour,
            "minute": minute,
            "index": index
        ]
        
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms") as? NSMutableArray
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
    
    func removeAlarmAtIndex(index: NSNumber) {
        var alarmsArray = NSUserDefaults.standardUserDefaults().valueForKey("alarms") as? NSMutableArray
        if alarmsArray == nil {
            alarmsArray = NSMutableArray()
        }
        
        let indexes = alarmsArray?.indexesOfObjectsPassingTest({ (item, i, stop) -> Bool in
            let dict = item as NSDictionary
            return dict.objectForKey("index") as NSNumber == index
        })
        
        alarmsArray?.removeObjectsAtIndexes(indexes!)
        
        NSUserDefaults.standardUserDefaults().setValue(alarmsArray, forKey: "alarms")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func resetAllAlarms() {
        NSUserDefaults.standardUserDefaults().setValue(NSMutableArray(), forKey: "alarms")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
