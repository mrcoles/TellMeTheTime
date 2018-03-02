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

class ViewController: UIViewController, UIGestureRecognizerDelegate, ChildToParentProtocol {

    //MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tableViewController: TableViewController!
    
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
    
    // segue to pass reference to self: https://stackoverflow.com/a/47447442/376489
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TableViewController,
            segue.identifier == "viewControllerToTable" {
            vc.delegate = self
        }
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

