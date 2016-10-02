//
//  Semester.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

class Semester: NSObject {
    
    var startDate: Date!
    var lastCount: Int!
    
    init(startDate: Date, lastCount: Int) {
        self.startDate = startDate
        self.lastCount = lastCount
    }
    
    func getWeekNo() -> Int {
        let startFirstWeekDay = getStartOfThatWeek(date: startDate)
        let currentFirstWeekDay = getStartOfThatWeek(date: Date())
        let weeks = getDaysBetween(from: startFirstWeekDay!, to: currentFirstWeekDay!) / 7
        if weeks >= 0 && weeks < lastCount {
            return 1 + weeks
        } else {
            return -1
        }
    }
    
    func getStartOfThatWeek(date: Date?) -> Date? {
        let calendar = Calendar.autoupdatingCurrent
        let currentDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date!)
        return calendar.date(from: currentDateComponents)
    }
    
    func getDaysBetween(from: Date, to: Date) -> Int {
        return Calendar.autoupdatingCurrent.dateComponents([Calendar.Component.day], from: from, to: to).day!
    }

}
