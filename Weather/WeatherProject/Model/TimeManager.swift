//
//  TimeManageger.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 07.04.2023.
//

import QuartzCore
import UIKit

final class TimeManager {
    static let shared = TimeManager()
    private var displayLink: CADisplayLink?
    // dictionary that stores label and time zone offset
    private var labelsToUpdate = [UILabel: Int]()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func startUpdatingTime(forLabel label: UILabel, timeZoneOffset: Int) {
        // creating a display link that will cause each frame to update
        displayLink = CADisplayLink(target: self, selector: #selector(updateTime))
        displayLink?.add(to: .current, forMode: .common)
        // saving label reference and time zone offset
        labelsToUpdate[label] = timeZoneOffset
    }
    
    func stopUpdatingTime(forLabel label: UILabel) {
        // removing label from labelsToUpdate dictionary
        labelsToUpdate.removeValue(forKey: label)
        // if there is no more label to update, stop the display link
        if labelsToUpdate.isEmpty {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    // MARK: - Selector
    @objc private func updateTime(_ displayLink: CADisplayLink) {
        // updating the time for each label from the labelsToUpdate dictionary
        let currentDate = Date()
        
        for (label, timeZoneOffset) in labelsToUpdate {
            let timezoneOffSet = TimeInterval(timeZoneOffset)
            let timeZoneDate = currentDate.addingTimeInterval(timezoneOffSet)
            let formattedDate = dateFormatter.string(from: timeZoneDate)
            label.text = formattedDate
        }
    }
}
