//
//  RecorderViewController.swift
//  GoForIt
//
//  Created by Lidner on 14/9/20.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    let recordButton = UIButton(type: .Custom) as UIButton
    let replayButton = UIButton(type: .Custom) as UIButton
    let cancelButton = UIButton(type: .Custom) as UIButton
    let uploadButton = UIButton(type: .Custom) as UIButton
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    let session = AVAudioSession.sharedInstance()
    
    var go_label: UILabel!
    var for_it_label: UILabel!
    
    let serviceURL = "http://goforit.solfanto.com"
//    let serviceURL = "http://localhost:3000"
    var outputFileURL = NSURL.fileURLWithPath((NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("newMessage.m4a"))
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "Go for it!"
        
        recordButton.setImage(UIImage(named: "microphone"), forState: .Normal)
        recordButton.setImage(UIImage(named: "record_button"), forState: .Highlighted)
        self.view.addSubview(recordButton)
        recordButton.alignCenterWithView(self.view)
        recordButton.constrainWidth("140")
        recordButton.constrainHeight("140")
        
        go_label = UILabel()
        go_label.text = "GO"
        go_label.textAlignment = .Center
        go_label.font = UIFont(name: "DINCondensed-Bold", size: 120.0)
        go_label.sizeToFit()
        self.view.addSubview(go_label)
        go_label.alignCenterXWithView(self.view, predicate: nil)
        go_label.constrainBottomSpaceToView(recordButton, predicate: "36")
        
        for_it_label = UILabel()
        for_it_label.text = "FOR IT!"
        for_it_label.textAlignment = .Center
        for_it_label.font = UIFont(name: "DINCondensed-Bold", size: 120.0)
        for_it_label.sizeToFit()
        self.view.addSubview(for_it_label)
        for_it_label.alignCenterXWithView(self.view, predicate: nil)
        for_it_label.constrainTopSpaceToView(recordButton, predicate: "0")
        
        replayButton.setImage(UIImage(named: "replay_button"), forState: .Normal)
        self.view.addSubview(replayButton)
        replayButton.alignCenterWithView(recordButton)
        replayButton.constrainWidth("60")
        replayButton.constrainHeight("60")
        replayButton.hidden = true
        
        cancelButton.setImage(UIImage(named: "cancel_button"), forState: .Normal)
        self.view.addSubview(cancelButton)
        cancelButton.constrainTrailingSpaceToView(replayButton, predicate: "-30")
        cancelButton.alignCenterYWithView(replayButton, predicate: nil)
        cancelButton.constrainWidth("60")
        cancelButton.constrainHeight("60")
        cancelButton.hidden = true
        
        
        uploadButton.setImage(UIImage(named: "upload_button"), forState: .Normal)
        self.view.addSubview(uploadButton)
        uploadButton.alignCenterXWithView(replayButton, predicate: nil)
        uploadButton.constrainBottomSpaceToView(replayButton, predicate: "-30")
        uploadButton.constrainWidth("60")
        uploadButton.constrainHeight("60")
        uploadButton.hidden = true
        
        recordButton.addTarget(self, action: "recordButtonPressed:", forControlEvents: .TouchDown)
        recordButton.addTarget(self, action: "recordButtonReleased:", forControlEvents: .TouchUpInside)
        recordButton.addTarget(self, action: "recordButtonReleased:", forControlEvents: .TouchUpOutside)
        replayButton.addTarget(self, action: "replayButtonTapped:", forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: .TouchUpInside)
        uploadButton.addTarget(self, action: "uploadButtonTapped:", forControlEvents: .TouchUpInside)
        
        let aboutButton = UIBarButtonItem(title: "About", style: UIBarButtonItemStyle.Done, target: self, action: "openAbout")
        self.navigationItem.rightBarButtonItem = aboutButton
        
        session.requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                self.setupRecorder()
            } else {
                print("Permission to record not granted")
            }
        })
    }
    
    func setupRecorder() {
//        var pathComponents = [NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as String, "newMessage.m4a"]
//        var outputFileURL = NSURL.fileURLWithPathComponents(pathComponents)
        
//        NSLog("\(outputFileURL)")
        
        do {
            // Setup audio session
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Define the recorder setting
        let recordSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2
        ] as [String : AnyObject]
        
        // Initiate and prepare the recorder
        recorder = try? AVAudioRecorder(URL: outputFileURL, settings: recordSettings)
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
        
        NSTimer.scheduledTimerWithTimeInterval(0.1,
            target: self,
            selector: "updateRecorderMeter:",
            userInfo: nil,
            repeats: true
        )
    }
    
    func recordButtonPressed(sender: UIButton) {
        if !recorder.recording {
            self.view.backgroundColor = UIColor.lightGrayColor()
            do {
                try session.setActive(true)
            } catch _ {
            }
            
            // Start recording
            recorder.record()
            
        }
    }
    
    func recordButtonReleased(sender: UIButton) {
        if recorder.recording {
            recorder.stop()
            player = try? AVAudioPlayer(contentsOfURL: recorder.url)
            player.delegate = self
            do {
                try session.setActive(false)
            } catch _ {
            }
            
            recordButton.hidden = true
            cancelButton.hidden = false
            replayButton.hidden = false
            uploadButton.hidden = false
        }
    }
    
    func replayButtonTapped(sender: UIButton) {
        if !recorder.recording && !player.playing {
            player.play()
        }
        else {
            player.pause()
        }
    }
    
    func cancelButtonTapped(sender: UIButton) {
        self.view.backgroundColor = UIColor.whiteColor()
        
        recordButton.hidden = false
        replayButton.hidden = true
        cancelButton.hidden = true
        uploadButton.hidden = true
    }
    
    func updateRecorderMeter(timer:NSTimer) {
        if recorder.recording {
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime % 60)
            let time = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            recorder.updateMeters()
            // var apc0 = recorder.averagePowerForChannel(0)
//            var peak0 = recorder.peakPowerForChannel(0)
            NSLog("\(time)")
        }
    }
    
    func uploadButtonTapped(sender: UIButton) {
        uploadButton.enabled = false
        let manager = AFHTTPRequestOperationManager()
        let parameters = ["uuid": Authentication.sharedInstance.uuid()]
        
        manager.POST("\(serviceURL)/cheeringup.json", parameters: parameters,
            constructingBodyWithBlock: { (formData: AFMultipartFormData!) in
                let data = NSData(contentsOfURL: self.outputFileURL)
                formData.appendPartWithFileData(data!, name: "cheeringup[audio_record]", fileName: "cheeringup.m4a", mimeType: "audio/m4a")
            },
            success: { operation, response in
                print("[success] operation: \(operation), response: \(response)")
                self.recordButton.hidden = false
                self.replayButton.hidden = true
                self.cancelButton.hidden = true
                self.uploadButton.hidden = true
                self.uploadButton.enabled = true
            },
            failure: { operation, error in
                print("[fail] operation: \(operation), error: \(error)")
                self.uploadButton.enabled = true
            }
        )
    }
    
    func openAbout() {
        let controller = AboutViewController()
        self.presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}
