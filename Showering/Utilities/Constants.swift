//
//  Constants.swift
//  Showering
//
//  Created by Krzysztof Kinal on 14/07/2021.
//

import Foundation
import UserNotifications

let UD_REF = UserDefaults.standard

struct Constants {
    static let hasBeenLaunchedBefore = "hasBeenLaunchedBefore"
    static let hasSeenOnboarding = "hasSeenOnboarding"
    static let shouldLowerRecognitionAccuracy = "shouldLowerRecognitionAccuracy"
    static let currentWeek = "currentWeek"
    static let waterUsed = "waterUsed"
    static let waterSaved = "waterSaved"
}


// GENERATE RANDOM ENTRIES
//        let dict: [String : Any] = ["r" : Float.random(in: 0...1), "g" : Float.random(in: 0...1), "b" : Float.random(in: 0...1), "a" : 1.0, "title" : weekdays.randomElement()!, "textValue" : "999", "height" : Double.random(in: 0...1)]
//        UserDefaults.standard.setValue(dict, forKey: weekdays.randomElement()!)
        
      
