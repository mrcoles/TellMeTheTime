//
//  TimeFormat.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 1/12/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

import Foundation
import AVFoundation

class TimeFormat {
    
    //MARK: Static Properties
    static let FMT12 = TimeFormat.dateFormatter("hh:mm:ss a") // 04:58:12 PM
    static let FMT24 = TimeFormat.dateFormatter("HH:mm:ss") // 16:58:12
    
    // TODO(l10n) - this might be over-optimized for english...
    static let FMT12_SAYABLE = TimeFormat.dateFormatter("h mm a") // 4 58 PM
    static let FMT24_SAYABLE = TimeFormat.dateFormatter("H mm") // 16 58
    
    static func dateFormatter(_ fromString: String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = fromString
        return fmt
    }
    
    //MARK: Properties
    var formatter = TimeFormat.FMT12
    var sayableFormatter = TimeFormat.FMT12_SAYABLE
    var use24 = false {
        didSet {
            formatter = use24 ? TimeFormat.FMT24 : TimeFormat.FMT12
            sayableFormatter = use24 ? TimeFormat.FMT24_SAYABLE : TimeFormat.FMT12_SAYABLE
        }
    }
    
    //MARK: Constructors
    
    init(use24: Bool) {
        self.use24 = use24
    }
    
    convenience init() {
        self.init(use24: false)
    }
    
    //MARK: Methods
    
    func currentTime() -> CurrentTime {
        return CurrentTime(Date(), formatter: formatter, sayableFormatter: sayableFormatter)
    }
}

struct CurrentTime {
    var date: Date
    var text: String
    var sayableText: String
    var seconds: Int
    
    init(_ date: Date, formatter: DateFormatter, sayableFormatter: DateFormatter) {
        let text = formatter.string(from: date)
        var sayableText = sayableFormatter.string(from: date)
        
        // HACK - make 05 sound like "oh five", maybe do this in a better way...
        sayableText = sayableText.replacingOccurrences(of: " 0", with: " oh ")
        
        self.date = date
        self.text = text
        self.sayableText = sayableText
        self.seconds = Calendar.current.component(.second, from: date)
    }
    
    func sayIt() {
        DispatchQueue.global(qos: .userInitiated).async {
            let string = self.sayableText
            let utterance = AVSpeechUtterance(string: string)
            
            // https://www.ikiapps.com/tips/2015/12/30/setting-voice-for-tts-in-ios
            // Language: en-IE, Name: Moira
            // REM utterance.voice = AVSpeechSynthesisVoice(identifier: "Moira")
            utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages[0])
            
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
        }
    }
}
