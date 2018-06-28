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
    static let LANGUAGE_CODE_EN = "en"
    static let LANGUAGE_CODE = Locale.current.languageCode ?? LANGUAGE_CODE_EN
    
    let synth: AVSpeechSynthesizer
    var speaking = false // used to no-op calls when already speaking
    var voices: [AVSpeechSynthesisVoice]
    var voice: AVSpeechSynthesisVoice
    
    var voiceRow: Int {
        get {
            return voices.index(of: voice) ?? 0
        }
    }
    
    override init() {
        synth = AVSpeechSynthesizer()
        
        let voices = AVSpeechSynthesisVoice.speechVoices().filter({ voice in
            return voice.language.starts(with: Speaker.LANGUAGE_CODE)
        })
        
        let currentLangCode = AVSpeechSynthesisVoice.currentLanguageCode()
        
        let tVoice = voices.first(where: { voice in
            return voice.language == currentLangCode
        })
        
        voice = tVoice ?? voices[0]
        
        self.voices = voices
        
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
            utterance.voice = self.voice
            utterance.pitchMultiplier = 1.4
            self.synth.speak(utterance)
        }
    }
    
    //MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("FINISHED SPEAKING!")
        speaking = false
    }
}

