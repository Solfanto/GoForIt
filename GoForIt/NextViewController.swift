//
//  NextViewController.swift
//  GoForIt
//
//  Created by 安部 裕介 on 9/20/14.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//
import UIKit

protocol NextViewDelegate: class {
    var newTime: NSDate? {get set}
}

class NextViewController: UIViewController {
    let pickerview = UIDatePicker()
    weak var delegate: NextViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let label = UILabel()
        label.frame = CGRectMake(0, 0, 100, 100)
        label.text = "Hello!"
        self.view.addSubview(label)
        
        pickerview.datePickerMode = .Time
        self.view.addSubview(pickerview)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "Close:")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "Save:")
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func Save(sender: UIBarButtonItem) {
        //var back = AlarmViewController()
        self.delegate?.newTime = pickerview.date
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
