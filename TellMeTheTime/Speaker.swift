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
    var speaking = false // used to no-op calls when already speaking
    
    var voices: [AVSpeechSynthesisVoice]
    
    override init() {
        synth = AVSpeechSynthesizer()
        
        voices = AVSpeechSynthesisVoice.speechVoices().filter({ voice in
            return voice.language.starts(with: Locale.current.languageCode ?? "en")
        })
        
        /*
        voices.map({ voice in
            return "\(voice.identifier) - \(voice.language) - \(voice.name)"
        }).joined(separator: "\n")
        */
    }

    func speak(text: String) {
        if (speaking) {
            return
        }
        speaking = true

        synth.delegate = self // TODO - can I put this in init?

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
        speaking = false
    }
}

