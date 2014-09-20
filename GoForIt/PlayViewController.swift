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
    let replayButton = UIButton.buttonWithType(.Custom) as UIButton
    
    var recordURL: NSURL!
    var recordPath = NSTemporaryDirectory().stringByAppendingPathComponent("currentMessage.m4a")

    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        replayButton.setImage(UIImage(named: "replay_button"), forState: .Normal)
        replayButton.frame = CGRect(
            x: self.view.frame.midX - 60 / 2,
            y: self.view.frame.midY - 60 / 2,
            width: 60,
            height: 60
        )
        self.view.addSubview(replayButton)
        
        replayButton.addTarget(self, action: "replayButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        replayButton.enabled = false
        
        let manager = AFHTTPRequestOperationManager()
        
        let parameters = ["uuid": Authentication.sharedInstance.uuid()]
        
        manager.GET("http://localhost:3000/cheeringup", parameters: parameters, success: {(operation, responseObject) in
            self.recordURL = NSURL(fileURLWithPath: self.recordPath)
            self.setupPlayer()
            self.replayButton.enabled = true
            
            NSLog("\(responseObject)")
            self.downloadCheeringup((responseObject as Dictionary)["audio_record"]!)
            }, failure: {(operation, error) in
            
        })
    }
    
    func downloadCheeringup(url: String) {
        let manager = AFHTTPRequestOperationManager()
        var operation = manager.GET(url, parameters: nil, success: {(operation, responseObject) in
            self.recordURL = NSURL(fileURLWithPath: self.recordPath)
            self.setupPlayer()
            self.replayButton.enabled = true
            
            }, failure: {(operation, error) in
                
        })
        
        operation.outputStream = NSOutputStream.outputStreamToFileAtPath(recordPath, append: false)
    }
    
    func setupPlayer() {
        if recordURL != nil {
            player = AVAudioPlayer(contentsOfURL: recordURL, error: nil)
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
