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

class ViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeFormat12Label: UILabel!
    @IBOutlet weak var timeFormat24Label: UILabel!
    @IBOutlet weak var timeFormatSwitch: UISwitch!
    
    var timer = Timer()
    var formatter = TimeFormat()
    var currentTime: CurrentTime?
    
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
                print("CURRENT TIME! \(currentTime.text)")
                currentTime.sayIt()
            }
        })
        
        updateClockLabel()
        updateTimeFormatLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func tapTimeFormatSwitch(_ sender: UISwitch) {
        let use24 = sender.isOn
        
        formatter.use24 = use24
        updateTimeFormatLabels()
        
        // redraw clock immediately
        currentTime = formatter.currentTime()
        updateClockLabel()
    }
    

    //MARK: Private helpers
    
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

