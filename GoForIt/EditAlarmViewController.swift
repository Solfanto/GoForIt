//
//  NextViewController.swift
//  GoForIt
//
//  Created by 安部 裕介 on 9/20/14.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//
import UIKit

protocol EditAlarmViewDelegate: class {
    var newTime: Dictionary<String,Int>! {get set}
    var currentId: Int? {get set}
}

class EditAlarmViewController: UIViewController {
    let pickerview = UIDatePicker()
    
    var id: Int?
    
    var delegate: EditAlarmViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        if self.id != nil {
            let alarm = Alarm.sharedInstance.getAlarms()[self.id!] as! NSDictionary
            let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
            components.hour = alarm["hour"] as! Int
            components.minute = alarm["minute"] as! Int
            pickerview.date = NSCalendar.currentCalendar().dateFromComponents(components)!
        }
        
        pickerview.datePickerMode = .Time
        self.view.addSubview(pickerview)
        pickerview.alignTopEdgeWithView(self.view, predicate: "\(self.navigationController!.navigationBar.frame.height)")
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "close:")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save:")
        self.navigationItem.rightBarButtonItem = saveButton
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save(sender: UIBarButtonItem) {
        //var back = AlarmViewController()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        let hourString = dateFormatter.stringFromDate(pickerview.date)
        dateFormatter.dateFormat = "mm"
        let minuteString = dateFormatter.stringFromDate(pickerview.date)
        
        
        self.delegate?.newTime = ["hour": Int(hourString)!, "minute": Int(minuteString)!]
        self.delegate?.currentId = self.id
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
