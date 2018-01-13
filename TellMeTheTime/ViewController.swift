//
//  ViewController.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 1/12/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

// TODO
//
// *   three buttons on bottom: mute | voice | 12 vs 24
// *   deal with main thread lag of talking
// *   get background audio working
// *   logo and other launch stuff
// *   something prettier on the main screen & some indication of nearing the minute
// *   extra voices: recording, conceptual sound
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
            if currentTime.seconds == 0 {
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

