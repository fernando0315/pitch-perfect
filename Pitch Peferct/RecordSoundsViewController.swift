//
//  RecordSoundsViewController.swift
//  Pitch Peferct
//
//  Created by Gerry Fernando Patia on 5/6/15.
//  Copyright (c) 2015 Gerry Fernando Patia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        //hide the stop button
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        
        RecordingInProgress.hidden = false
        RecordingInProgress.text = "Tap to Record"
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        pauseButton.hidden = false
        recordButton.enabled = false
        
        //show text: "record in progress
        RecordingInProgress.text = "Record in Progress"
        
        //start recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        if (audioRecorder == nil) {
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }

        audioRecorder.record()
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        audioRecorder.pause()
        
        recordButton.enabled = true
        RecordingInProgress.text = "Pause (Tap to continue)"
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            recordedAudio.title = recorder.url.lastPathComponent
            
            //Perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:AudioEffectsViewController = segue.destinationViewController as! AudioEffectsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        RecordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }


}

