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
    @IBOutlet weak var startButton: UIButton!
    
    var timer = Timer()
    var formatter = TimeFormat()
    
    //MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // block: (Timer) -> Void
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            let currentTime = self.formatter.currentTime()
            self.timeLabel.text = currentTime.text
            if currentTime.seconds % 5 == 0 {
                print("CURRENT TIME! \(currentTime.text)")
                currentTime.sayIt()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func tapStart(_ sender: UIButton) {
        formatter.use24 = !formatter.use24
    }
    

    //MARK: Private helpers
}

