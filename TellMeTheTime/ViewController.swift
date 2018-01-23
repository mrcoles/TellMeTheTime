//
//  ViewController.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 1/12/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

// TODO
//
// *   logo and other launch stuff
// *   extra voices: recording, conceptual sound
// *   PUNT: something prettier on the main screen & some indication of nearing the minute
// *   PUNT get lock screen controls working? MPRemoteCommandCenter
// *   X three buttons on bottom: mute (or play/stop?) | voice select | 12hr vs 24hr
// *   X auto list of system voices
// *   X deal with main thread lag of talking
// *   X get background audio working
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeFormat12Label: UILabel!
    @IBOutlet weak var timeFormat24Label: UILabel!
    @IBOutlet weak var timeFormatSwitch: UISwitch!
    
    
    @IBOutlet weak var volumeOnLabel: UILabel!
    @IBOutlet weak var volumeOffLabel: UILabel!
    @IBOutlet weak var volumeSwitch: UISwitch!
    
    @IBOutlet weak var voicePicker: UIPickerView!
    
    let speaker = Speaker()
    
    var timer = Timer()
    var formatter = TimeFormat()
    var currentTime: CurrentTime?
    var muted = false
    var backgroundLayer: CAGradientLayer?
    
    //MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup timer for updating the clock
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            let currentTime = self.formatter.currentTime()
            self.currentTime = currentTime

            self.updateClockLabel()
            if currentTime.seconds == 0 {
                print("CURRENT TIME! \(currentTime.text) (muted? \(self.muted))")
                self.sayTime()
            }
        })
        
        // Setup voicePicker
        voicePicker.selectRow(speaker.voiceRow, inComponent: 0, animated: false)

        // Update UI
        timeFormatSwitch.isOn = formatter.use24
        volumeSwitch.isOn = muted
        updateClockLabel()
        updateTimeFormatLabels()
        updateVolumeLabels()
        
        // Setup gesture recognizer for time label
        timeLabel.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTimeLabel(_:)))
        timeLabel.addGestureRecognizer(tap)
        tap.delegate = self
        
        // Setup rotate listener
        NotificationCenter.default.addObserver(
            forName: .UIDeviceOrientationDidChange,
            object: nil,
            queue: .main,
            using: { notification in
                self.setupBackground()
            }
        )
        
        setupBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func tapTimeLabel(_ sender: UITapGestureRecognizer) {
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
    
    @IBAction func tapVolumeSwitch(_ sender: UISwitch) {
        muted = sender.isOn
        updateVolumeLabels()
    }
    
    //MARK: UIPickerViewDataSource and UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speaker.voices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let voice = speaker.voices[row]
        return "\(voice.name) (\(voice.language))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let voice = speaker.voices[row]
        speaker.voice = voice
    }
    
    //MARK: Private helpers
    
    func sayTime() {
        if !muted, let currentTime = currentTime {
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
    
    func updateVolumeLabels() {
        volumeOnLabel.alpha = muted ? 0.25 : 1.0
        volumeOffLabel.alpha = muted ? 1.0 : 0.25
        timeLabel.alpha = muted ? 0.5 : 1.0
    }
    
    func toggleBold(label: UILabel, setBold: Bool) {
        if let font = label.font {
            let size = font.pointSize
            label.font = setBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }
    }
    
    func setupBackground() {
        return
        
        /*
        let view = timeLabel! // self.view.frame
        if let backgroundLayer = self.backgroundLayer {
            backgroundLayer.frame = view.frame
        } else {
            let colorTop = UIColor(red: 165.0 / 255.0, green: 158.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0).cgColor
            let colorBot = UIColor(red: 100.0 / 255.0, green: 217.0 / 164.0, blue: 250.0 / 255.0, alpha: 1.0).cgColor
            
            let gl = CAGradientLayer()
            gl.colors = [colorTop, colorBot]
            gl.locations = [0.2, 1.0]
            
            view.backgroundColor = UIColor.clear
            let backgroundLayer = gl
            backgroundLayer.frame = view.frame
            view.layer.insertSublayer(backgroundLayer, at: 0)
            self.backgroundLayer = backgroundLayer
        }
        */
    }
}

