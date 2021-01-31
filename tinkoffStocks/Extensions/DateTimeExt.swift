//
//  DateTimeExt.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 31.01.2021.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

func stringFromTimeInterval(interval: TimeInterval) -> NSString {
    
    let ti = NSInteger(interval)
    
    let ms = Int(Int(interval) * 1000)
    
    let seconds = ti % 60
    let minutes = (ti / 60) % 60
    let hours = (ti / 3600)
    
    return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
}

func UTCToLocal(currentDate: Date, format: String = "dd.MM.yyyy HH:mm") -> String {
    // 4) Set the current date, altered by timezone.
    let dateString = currentDate.getFormattedDate(format: format)
    return dateString
}

func UTCtoClockTimeOnly(currentDate: Date, format: String = "HH:mm") -> String {
    // 4) Set the current date, altered by timezone.
    let dateString = currentDate.getFormattedDate(format: format)
    return dateString
}



