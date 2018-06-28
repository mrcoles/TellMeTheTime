//
//  ViewController.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 1/12/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

// TODO
//
// *   launch
// *   persist state
// *   swipe up to pull settings
// *   night mode
// *   extra voices: recording, conceptual sound
// *   PUNT get lock screen controls working? MPRemoteCommandCenter
// *   X mute (or play/stop?) | voice select | 12hr vs 24hr
// *   X auto list of system voices
// *   X deal with main thread lag of talking
// *   X get background audio working
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, ChildToParentProtocol {

    //MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    
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

        // Update UI
        updateClockLabel()
        
        // Setup gesture recognizer for time label
        timeLabel.isUserInteractionEnabled = true
        let timeTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTimeLabel(_:)))
        timeLabel.addGestureRecognizer(timeTap)
        timeTap.delegate = self
        
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
    
    //MARK: Navigation
    
    // segue to pass reference to self: https://stackoverflow.com/a/47447442/376489
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVc = segue.destination as? UINavigationController, let vc = navVc.topViewController as? TableViewController, segue.identifier == "clockToSettings" {
            vc.delegate = self
        }
    }
    
    @IBAction func undwindToClockView(sender: UIStoryboardSegue) {
        // called when returning from settings view...
    }
    
    //MARK: Actions
    
    @objc func tapTimeLabel(_ sender: UITapGestureRecognizer) {
        sayTime()
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
    
    func setupBackground() {

        let view = self.view! // timeLabel! // self.view.frame
        if let backgroundLayer = self.backgroundLayer {
            backgroundLayer.frame = view.frame
        } else {
            // let colorTop = UIColor(red: 165.0 / 255.0, green: 158.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0).cgColor
            // let colorBot = UIColor(red: 100.0 / 255.0, green: 217.0 / 164.0, blue: 250.0 / 255.0, alpha: 1.0).cgColor
            
            // some ideas https://digitalsynopsis.com/design/beautiful-color-gradients-backgrounds/
            // let hexTop = 0x13547A
            // let hexBot = 0x80D0C7
            let hexTop = 0x93A5CF
            let hexBot = 0xE4EFE9

            let colorTop = UIColor(hex: hexTop).cgColor
            let colorBot = UIColor(hex: hexBot).cgColor
            
            let gl = CAGradientLayer()
            gl.colors = [colorTop, colorBot]
            gl.locations = [0.25, 1.0]
            
            view.backgroundColor = UIColor.clear
            let backgroundLayer = gl
            backgroundLayer.frame = view.frame
            view.layer.insertSublayer(backgroundLayer, at: 0)
            self.backgroundLayer = backgroundLayer
        }
    }
}

