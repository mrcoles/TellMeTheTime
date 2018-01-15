//
//  ViewController.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 1/12/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

// TODO
//
// *   get lock screen controls working? MPRemoteCommandCenter
// *   three buttons on bottom: mute (or play/stop?) | voice select | 12hr vs 24hr
// *   logo and other launch stuff
// *   something prettier on the main screen & some indication of nearing the minute
// *   extra voices: recording, conceptual sound
// *   X deal with main thread lag of talking
// *   X get background audio working

//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate, AVSpeechSynthesizerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeFormat12Label: UILabel!
    @IBOutlet weak var timeFormat24Label: UILabel!
    @IBOutlet weak var timeFormatSwitch: UISwitch!
    
    @IBOutlet weak var playMuteButton: UIButton!
    
    let speaker = Speaker()
    
    var timer = Timer()
    var formatter = TimeFormat()
    var currentTime: CurrentTime?
    var muted = false
    
    //MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // block: (Timer) -> Void
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            let currentTime = self.formatter.currentTime()
            self.currentTime = currentTime

            self.updateClockLabel()
            if currentTime.seconds == 0 {
                print("CURRENT TIME! \(currentTime.text) (muted? \(self.muted))")
                self.sayTime()
            }
        })
        
        updateClockLabel()
        updateTimeFormatLabels()
        
        timeLabel.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTimeLabel(_:)))
        timeLabel.addGestureRecognizer(tap)
        tap.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func tapTimeLabel(_ sender: UITapGestureRecognizer) {
        print("TAPPED?!?")
        
        sayTime()
    }
    
    @IBAction func tapTimeFormatSwitch(_ sender: UISwitch) {
        let use24 = sender.isOn
        
        formatter.use24 = use24
        updateTimeFormatLabels()
        
        // redraw clock immediately
        currentTime = formatter.currentTime()
        updateClockLabel()
    }
    
    @IBAction func tapPlayMuteButton(_ sender: UIButton) {
        muted = !muted
        
        playMuteButton.setTitle(muted ? "Active" : "Mute", for: .normal)
    }
    
    //MARK: Private helpers
    
    func sayTime() {
        if !muted, let currentTime = currentTime {
            print("SPEAKING TRUE!")
            
            speaker.speak(text: currentTime.sayableText)
        }
    }
    
    func updateClockLabel() {
        if let currentTime = currentTime {
            timeLabel.text = currentTime.text
        }
    }
    
    func updateTimeFormatLabels() {
        let use24 = formatter.use24
        toggleBold(label: timeFormat24Label, setBold: use24)
        toggleBold(label: timeFormat12Label, setBold: !use24)
    }
    
    func toggleBold(label: UILabel, setBold: Bool) {
        if let font = label.font {
            let size = font.pointSize
            label.font = setBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }
    }
}

