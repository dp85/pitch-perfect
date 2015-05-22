//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Dave Patrick on 5/13/15.
//  Copyright (c) 2015 Dave Patrick. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        
        // perform work to set up AVAudioPlayer and AVAudioEngine
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handles action when the slow (snail) button is touched
    @IBAction func slowButtonTouched(sender: UIButton) {
        playAudioWithVariableSpeed(playSpeed: 0.5)
    }

    // Handles action when the fast (rabbit) button is touched
    @IBAction func fastButtonTouched(sender: UIButton) {
        playAudioWithVariableSpeed(playSpeed: 2.0)
    }
    
    // Handles action when the highpitch (chipmunk) button is touched
    @IBAction func chipmunkButtonTouched(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    // Handles action when the lowpitch (darth vader) button is touched
    @IBAction func darthButtonTouched(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Handles action when stop button is touched
    @IBAction func stopButtonTouched(sender: UIButton) {
        // stop both the aduioEngine and audioPlayer in case one of them is currently playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // Audio function that plays the aduio loaded in audioEngine using the pitch varaiance
    // specified
    func playAudioWithVariablePitch(pitch: Float){
        // stop both the aduioEngine and audioPlayer in case one of them is currently playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // Plays audio in audioPlayer using the speed variance specified.
    // default value of speed is to play at actual (1.0) speed.
    func playAudioWithVariableSpeed(playSpeed: Float = 1.0) {
        // stop both the aduioEngine and audioPlayer in case one of them is currently playing
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = playSpeed
        audioPlayer.play()
    }

}
