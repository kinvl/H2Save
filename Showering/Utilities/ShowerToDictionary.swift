//
//  ShowerToArray.swift
//  Showering
//
//  Created by Krzysztof Kinal on 15/07/2021.
//

import Foundation

class ShowerDictionarySaver {
    
    private var showerDictionary: [String: Any] = [:]
    
    func saveDictionaryWithShowerTimeElapsed(time: TimeInterval) {
        setupShowerDictionary(elapsedTime: time)
        writeDictionaryToUserDefaults(dictionary: showerDictionary)
        
    }
    
    private func writeDictionaryToUserDefaults(dictionary: Dictionary<String, Any>) {
        if let key = dictionary["title"] as? String {
            UD_REF.setValue(dictionary, forKey: key)
        }
    }
    
    private func setupShowerDictionary(elapsedTime: TimeInterval) {
        let height = elapsedTime * (1/300)
        let textValue = String(Int(elapsedTime))
        let title = todaysWeekDay()
        let color = todaysColor()
        
        showerDictionary["height"] = height
        showerDictionary["textValue"] = textValue
        showerDictionary["title"] = title
        showerDictionary["r"] = color[0]
        showerDictionary["g"] = color[1]
        showerDictionary["b"] = color[2]
        showerDictionary["a"] = color[3]

    }
    
    private func todaysColor() -> [Float] {
        let weekday = todaysWeekDay()
        
        switch weekday {
        case "Mon":
            return [1.00, 0.09, 0.09, 1.00]
        case "Tue":
            return [1.00, 0.57, 0.30, 1.00]
        case "Wed":
            return [1.00, 0.87, 0.35, 1.00]
        case "Thu":
            return [0.49, 0.85, 0.34, 1.00]
        case "Fri":
            return [0.32, 0.44, 1.00, 1.00]
        case "Sat":
            return [0.55, 0.32, 1.00, 1.00]
        case "Sun":
            return [0.57, 0.00, 0.84, 1.00]
        default:
            return [0.00, 0.00, 0.00, 1.00]
        }
    }
    
    private func todaysWeekDay() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEE"
          let weekDay = dateFormatter.string(from: Date())
          return weekDay
        
    }

}
