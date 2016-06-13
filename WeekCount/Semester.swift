//
//  Semester.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

class Semester: NSObject {
    
    var startDate: NSDate!
    var lastCount: Int!
    
    init(startDate: NSDate, lastCount: Int) {
        self.startDate = startDate
        self.lastCount = lastCount
    }
    
    func getWeekNo() -> Int {
        let startFirstWeekDay = getStartOfThatWeek(startDate)
        let currentFirstWeekDay = getStartOfThatWeek(NSDate())
        let weeks = getDaysBetween(startFirstWeekDay!, to: currentFirstWeekDay!) / 7
        if weeks >= 0 && weeks < lastCount {
            return 1 + weeks
        } else {
            return -1
        }
    }
    
    func getStartOfThatWeek(date: NSDate?) -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components([.YearForWeekOfYear, .WeekOfYear ], fromDate: date!)
        return calendar.dateFromComponents(currentDateComponents)
    }
    
    func getDaysBetween(from: NSDate, to: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: from, toDate: to, options: []).day
    }

}