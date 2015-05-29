//
//  PlaySoundsViewController.swift
//  Pitch Peferct
//
//  Created by Gerry Fernando Patia on 5/11/15.
//  Copyright (c) 2015 Gerry Fernando Patia. All rights reserved.
//

import UIKit
import AVFoundation

class AudioEffectsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioEcho:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
         playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAudio()
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        playAudioWithEffect(changePitchEffect)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAudio()
        
        audioPlayer.rate = 1.0
        audioPlayer.currentTime = 0
        audioEcho.currentTime = 0
        
        audioPlayer.play()
        audioEcho.playAtTime(audioEcho.deviceCurrentTime + 0.1)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAudio()
        
        var audioReverb = AVAudioUnitReverb()
        audioReverb.wetDryMix = 60
        
        playAudioWithEffect(audioReverb)
    }
    
    func playAudioWithEffect(input: AVAudioNode){
        var audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(input)
        audioEngine.connect(audioPlayerNode, to: input, format: nil)
        audioEngine.connect(input, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAudio()
        playAudioWithRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        stopAudio()
        playAudioWithRate(1.5)
    }

    func playAudioWithRate(rate: Float){
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        
        audioPlayer.play()
    }
    
    func stopAudio(){
        audioPlayer.stop()
        audioEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
