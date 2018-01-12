//
//  TimeFormat.swift
//  TellMeTheTime
//
//  Created by Peter Coles on 1/12/18.
//  Copyright © 2018 Peter Coles. All rights reserved.
//

import Foundation

class TimeFormat {
    
    //MARK: Static Properties
    static let FMT12 = TimeFormat.dateFormatter("hh:mm:ss a")
    static let FMT24 = TimeFormat.dateFormatter("HH:mm:ss")
    
    static func dateFormatter(_ fromString: String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = fromString
        return fmt
    }
    
    //MARK: Properties
    var formatter = TimeFormat.FMT12
    var use24 = false {
        didSet {
            formatter = use24 ? TimeFormat.FMT24 : TimeFormat.FMT12
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
        return CurrentTime(Date(), formatter: formatter)
    }
}

struct CurrentTime {
    var date: Date
    var text: String
    var seconds: Int
    
    init(_ date: Date, formatter: DateFormatter) {
        let string = formatter.string(from: date)
        
        self.date = date
        self.text = string
        self.seconds = Calendar.current.component(.second, from: date)
    }
}
