//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Gokhan Namal on 2.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    enum RecordingState {
        case recording
        case notRecording
    }
       
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
    }
    
    func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let urlString = "\(dirPath)/\(recordingName)"
        let filePath = URL(string: urlString)
 
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func recordButton(_ sender: Any) {
        self.changeState(state: .recording)
    }
    
    @IBAction func stopButton(_ sender: Any) {
        self.changeState(state: .notRecording)
    }
    
    func changeState(state: RecordingState) {
        switch state {
        case .recording:
            self.startRecording()
            self.configureUI(state)
        case .notRecording:
            self.stopRecording()
            self.configureUI(state)
        }
    }
    
    func configureUI(_ state: RecordingState) {
        switch state {
        case .recording:
            messageLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
            stopButton.isEnabled = true
        case .notRecording:
            messageLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder?.url)
        } else {
            print("recording is not succesfull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedURL
        }
    }
}

