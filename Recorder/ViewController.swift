//
//  ViewController.swift
//  Recorder
//
//  Created by Siddhi Panchal on 10/21/19.
//  Copyright © 2019 Siddhi Panchal. All rights reserved.
//

import UIKit
import AVFoundation         //lets us use audio and video in app


class ViewController: UIViewController, AVAudioRecorderDelegate  {
    
    var recordingSession:AVAudioSession! //audio recording session
    var audioRecorder:AVAudioRecorder!   //audio recorder, to record
    var numberOfRecords = 0
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    
    @IBAction func record(_ sender: Any)
    {
        //check if we have active recorder
        if audioRecorder == nil
        {
            numberOfRecords += 1
            //get the path, give recording a name to refer to
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //start audio recording
            do
            {
                audioRecorder = try AVAudioRecorder(url:  filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                buttonLabel.setTitle("stop recording", for: .normal)
            }
            catch
            {
                displayAlert(title: "Oops!", message: "recording failed.")
            }
            
        }
        else
        {
            //stopping audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            buttonLabel.setTitle("start recording", for: .normal)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
         //setting up session
        recordingSession = AVAudioSession.sharedInstance()
        //getting permission to record from user
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission
            {
                print("Accepted")
            }
        }
    }

    
    //function that gets path to directory
    //where we save recordings
    func getDirectory() -> URL
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)              //search for doc directory
        let documentDirectory =  path[0]  // take first as path
        return documentDirectory          //return the url to take doc directory
    }
    //function that displays alerts
    func displayAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }

}

