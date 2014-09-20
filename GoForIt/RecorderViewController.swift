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
    let recordButton = UIButton.buttonWithType(.Custom) as UIButton
    let replayButton = UIButton.buttonWithType(.Custom) as UIButton
    let cancelButton = UIButton.buttonWithType(.Custom) as UIButton
    let uploadButton = UIButton.buttonWithType(.Custom) as UIButton
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    let session = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        recordButton.setImage(UIImage(named: "microphone"), forState: .Normal)
        recordButton.setImage(UIImage(named: "record_button"), forState: .Highlighted)
        recordButton.frame = CGRect(
            x: self.view.frame.midX - 140 / 2,
            y: self.view.frame.midY - 140 / 2,
            width: 140,
            height: 140
        )
        self.view.addSubview(recordButton)
        
        replayButton.setImage(UIImage(named: "replay_button"), forState: .Normal)
        replayButton.frame = CGRect(
            x: self.view.frame.midX - 60 / 2,
            y: self.view.frame.midY - 60 / 2,
            width: 60,
            height: 60
        )
        self.view.addSubview(replayButton)
        replayButton.hidden = true
        
        cancelButton.setImage(UIImage(named: "cancel_button"), forState: .Normal)
        cancelButton.frame = CGRect(
            x: self.view.frame.midX - 140,
            y: self.view.frame.midY - 60 / 2,
            width: 60,
            height: 60
        )
        self.view.addSubview(cancelButton)
        cancelButton.hidden = true
        
        recordButton.addTarget(self, action: "recordButtonPressed:", forControlEvents: .TouchDown)
        
        recordButton.addTarget(self, action: "recordButtonReleased:", forControlEvents: .TouchUpInside | .TouchUpOutside)
        
        replayButton.addTarget(self, action: "replayButtonTapped:", forControlEvents: .TouchUpInside)
        
        cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: .TouchUpInside)
        
        
        session.requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                self.setupRecorder()
            } else {
                println("Permission to record not granted")
            }
        })
    }
    
    func setupRecorder() {
//        var pathComponents = [NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as String, "newMessage.m4a"]
//        var outputFileURL = NSURL.fileURLWithPathComponents(pathComponents)
        var outputFileURL = NSURL.fileURLWithPath(NSTemporaryDirectory().stringByAppendingPathComponent("newMessage.m4a"))
        NSLog("\(outputFileURL)")
        
        // Setup audio session
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Define the recorder setting
        var recordSettings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2
        ]
        
        // Initiate and prepare the recorder
        recorder = AVAudioRecorder(URL: outputFileURL, settings: recordSettings, error: nil)
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
        
        var recorderTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
            target: self,
            selector: "updateRecorderMeter:",
            userInfo: nil,
            repeats: true
        )
    }
    
    func recordButtonPressed(sender: UIButton) {
        if !recorder.recording {
            self.view.backgroundColor = UIColor.lightGrayColor()
            session.setActive(true, error: nil)
            
            // Start recording
            recorder.record()
            
        }
    }
    
    func recordButtonReleased(sender: UIButton) {
        if recorder.recording {
            recorder.stop()
            player = AVAudioPlayer(contentsOfURL: recorder.url, error: nil)
            player.delegate = self
            session.setActive(false, error: nil)
            
            recordButton.hidden = true
            cancelButton.hidden = false
            replayButton.hidden = false
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
    }
    
    func updateRecorderMeter(timer:NSTimer) {
        if recorder.recording {
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime % 60)
            let time = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            recorder.updateMeters()
            var apc0 = recorder.averagePowerForChannel(0)
//            var peak0 = recorder.peakPowerForChannel(0)
            NSLog("\(time)")
        }
    }
    
    
}
