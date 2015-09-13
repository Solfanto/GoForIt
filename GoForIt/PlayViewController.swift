//
//  RecorderViewController.swift
//  GoForIt
//
//  Created by Lidner on 14/9/20.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController, AVAudioPlayerDelegate {
    let replayButton = UIButton(type: .Custom) as UIButton
    
    var recordURL: NSURL!
    var recordPath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("currentMessage.m4a")
    
    let serviceURL = "http://goforit.solfanto.com"
    //    let serviceURL = "http://localhost:3000"
    
    var player: AVAudioPlayer!
    var cheer_label: UILabel!
    var me_up_label: UILabel!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "Cheer me up!"
        
        replayButton.setImage(UIImage(named: "replay_button"), forState: .Normal)
        replayButton.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(replayButton)
        replayButton.alignCenterWithView(self.view)
        replayButton.constrainWidth("60")
        replayButton.constrainHeight("60")
        
        cheer_label = UILabel()
        cheer_label.text = "CHEER"
        cheer_label.textAlignment = .Center
        cheer_label.font = UIFont(name: "DINCondensed-Bold", size: 120.0)
        cheer_label.sizeToFit()
        self.view.addSubview(cheer_label)
        cheer_label.alignCenterXWithView(self.view, predicate: nil)
        cheer_label.constrainBottomSpaceToView(replayButton, predicate: "0")
        
        me_up_label = UILabel()
        me_up_label.text = "ME UP"
        me_up_label.textAlignment = .Center
        me_up_label.font = UIFont(name: "DINCondensed-Bold", size: 120.0)
        me_up_label.sizeToFit()
        self.view.addSubview(me_up_label)
        me_up_label.alignCenterXWithView(self.view, predicate: nil)
        me_up_label.constrainTopSpaceToView(replayButton, predicate: "36")
        
        
        
        replayButton.addTarget(self, action: "replayButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        replayButton.enabled = false
        
        let manager = AFHTTPRequestOperationManager()
        
        let parameters = ["uuid": Authentication.sharedInstance.uuid()]
        
        manager.GET("\(serviceURL)/cheeringup", parameters: parameters, success: { (operation, responseObject) in
            self.recordURL = NSURL(fileURLWithPath: self.recordPath)
            self.setupPlayer()
            self.replayButton.enabled = true
            
            NSLog("\(responseObject)")
            if (responseObject as! Dictionary)["status"] == "ok" {
                self.downloadCheeringup((responseObject as! Dictionary)["audio_record"]!)
            }
            
        }, failure: {(operation, error) in
            NSLog("error: \(error)")
        })
    }
    
    func downloadCheeringup(url: String) {
        let manager = AFHTTPRequestOperationManager()
        let operation = manager.GET(url, parameters: nil, success: {(operation, responseObject) in
            self.recordURL = NSURL(fileURLWithPath: self.recordPath)
            self.setupPlayer()
            self.replayButton.enabled = true
            
        }, failure: {(operation, error) in
            NSLog("error: \(error)")
        })
        
        operation!.outputStream = NSOutputStream(toFileAtPath: recordPath, append: false)
    }
    
    func setupPlayer() {
        if recordURL != nil {
            player = try? AVAudioPlayer(contentsOfURL: recordURL)
            player?.delegate = self
        }
    }

    
    func replayButtonTapped(sender: UIButton) {
        if recordURL != nil {
            if player != nil && !player.playing {
                player.play()
            }
            else if player != nil {
                player.pause()
            }
        }
    }
}
