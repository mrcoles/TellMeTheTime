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
    
    let session: AVAudioSession
    
    //MARK: Constructors
    
    init(use24: Bool) {
        self.use24 = use24
        
        // TODO - should I put this in `fun application` start? https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/MediaPlaybackGuide/Contents/Resources/en.lproj/ConfiguringAudioSettings/ConfiguringAudioSettings.html#//apple_ref/doc/uid/TP40016757-CH9-SW1
        
        // Access the shared, singleton audio session instance
        session = AVAudioSession.sharedInstance()
        
        do {
            // TODO - move this to somewhere else? AppDelegate?
            try session.setCategory(AVAudioSessionCategoryPlayback, with:
                AVAudioSessionCategoryOptions.mixWithOthers)
            // TODO - consider setting https://developer.apple.com/documentation/avfoundation/avaudiosessionmodespokenaudio for the session mode?
        } catch {
            fatalError("Unable to set audio session!")
        }
    }
    
    convenience init() {
        self.init(use24: false)
    }
    
    //MARK: Methods
    
    func currentTime() -> CurrentTime {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        let date = formatter.date(from: "03:00:00")!
        return CurrentTime(Date(), formatter: formatter, sayableFormatter: sayableFormatter, use24: use24)
    }
}

struct CurrentTime {
    var date: Date
    var text: String
    var sayableText: String
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    init(_ date: Date, formatter: DateFormatter, sayableFormatter: DateFormatter, use24: Bool) {
        let text = formatter.string(from: date)
        var sayableText = sayableFormatter.string(from: date)
        
        // HACK - change "00"...
        // if 12 hr time - remove it
        // if 24 hr time - say hundred? TODO(l10n)
        let ohohReplace = use24 ? " hundred" : ""
        sayableText = sayableText.replacingOccurrences(of: " 00", with: ohohReplace)
        // HACK - make 05 sound like "oh five", maybe do this in a better way...
        sayableText = sayableText.replacingOccurrences(of: " 0", with: " oh ")
        
        self.date = date
        self.text = text
        self.sayableText = sayableText
        
        let cal = Calendar.current
        
        self.hours = cal.component(.hour, from: date)
        self.minutes = cal.component(.minute, from: date)
        self.seconds = cal.component(.second, from: date)
    }
}
