//
//  Speaker.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 1/15/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

import Foundation
import AVFoundation


class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    
    let synth: AVSpeechSynthesizer
    var callback: (() -> Void)?
    
    override init() {
        synth = AVSpeechSynthesizer()
    }

    func speak(text: String, callback: (() -> Void)?) {
        synth.delegate = self // TODO - can I put this in init?
        self.callback = callback
        
        DispatchQueue.global(qos: .userInitiated).async {
            let utterance = AVSpeechUtterance(string: text)
            
            // https://www.ikiapps.com/tips/2015/12/30/setting-voice-for-tts-in-ios
            // Language: en-IE, Name: Moira
            // REM utterance.voice = AVSpeechSynthesisVoice(identifier: "Moira")
            utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages[0])
            
            self.synth.speak(utterance)
        }
    }
    
    //MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("FINISHED SPEAKING!")
        if let callback = callback {
            DispatchQueue.main.async {
                callback()
            }
        }

    }
    
}

