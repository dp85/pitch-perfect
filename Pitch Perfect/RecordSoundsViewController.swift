//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by David Patrick on 5/9/15.
//  Copyright (c) 2015 Dave Patrick. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // local variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // called each time right before the View is shown
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button, enable record
        stopButton.hidden = true
        recordButton.enabled = true
        
        //Set the recording label to 'Tap to Record'
        recordingLabel.text = "Tap to Record"
    }

    // handles the action for when audio is to be recorded. this happens when
    // a user touches the microphone button
    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        recordingLabel.text = "Recording in Progress"
        stopButton.hidden = false
        
        // Record user's voice
        // get a directory to save the recording to.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        // construct a file name based on the current date and time
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    // handles the action when the user wants to stop recording. this is when
    // the stop button is touched
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    // we registered this class as a delegate for the audioRecorder instance. When the audioRecorder
    // has finished, this method gets invoked.
    // flag will be true if the audio recorded successfully. False if there was an error
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag)
        {
            // If audio was recorded successfully, create a RecordedAudio object with
            // the filepath and title.
            recordedAudio = RecordedAudio(FilePathURL: recorder.url, Title: recorder.url.lastPathComponent)
            // transition to PlaySoundsViewController
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    // We override UIViewControllers prepareForSegue method so we can send the recordedAudio
    // object to it that contains the path to the audio that was recorded by this view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

