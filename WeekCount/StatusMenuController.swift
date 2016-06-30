//
//  StatusMenuController.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

let DEFAULT_STARTDATE = NSDate.init(timeIntervalSince1970: 1456099200)
let DEFAULT_LASTCOUNT = 18
let DEFAULT_DISPLAYFORMAT = "Week {W}"
let DEFAULT_FONTSIZE: Float = 14.25

let NSStatusBarItemPrioritySystem = INT_MAX - 2
let NSStatusBarItemPrioritySpotlight = INT_MAX - 1
let NSStatusBarItemPriorityNotificationCenter = INT_MAX


class StatusMenuController: NSObject, PreferencesWindowDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var dateMenuItem: NSMenuItem!
    
    var preferencesWindow: PreferencesWindow!
    var aboutWindow: AboutWindow!
    var startDate: NSDate!
    var lastCount: Int!
    var displayFormat: String!
    var fontSize: Float!
    var autoLaunch: Int!
    
    var sem: Semester!
    
    var statusItem: NSStatusItem!// = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        statusItem = NSStatusItem()._initInStatusBar(NSStatusBar.systemStatusBar(), withLength: NSVariableStatusItemLength, withPriority: NSStatusBarItemPrioritySystem)
        
        preferencesWindow = PreferencesWindow()
        aboutWindow = AboutWindow()
        preferencesWindow.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateAll"), name: "URLSchemesUpdate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("showPreferencesWindow:"), name: "URLSchemesShowPreferences", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("quit"), name: "URLSchemesQuit", object: nil)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateAll"), userInfo: nil, repeats: true)
        let loop = NSRunLoop.mainRunLoop()
        loop.addTimer(timer, forMode: NSDefaultRunLoopMode)
        statusMenu.itemArray.last!.action = Selector("terminate:")
        statusItem.menu = statusMenu
        
    }
    
    @IBAction func showPreferencesWindow(sender: NSMenuItem) {
        NSApp.activateIgnoringOtherApps(true)
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func showAboutWindow(sender: NSMenuItem) {
        NSApp.activateIgnoringOtherApps(true)
        aboutWindow.showWindow(nil)
    }
    
    func quit() {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func resetPreferences() {
        NSUserDefaults.standardUserDefaults().setPersistentDomain(["":""], forName: NSBundle.mainBundle().bundleIdentifier!)
        updateAll()
    }
    
    func updateAll() {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        formatter.dateStyle = .FullStyle
        dateMenuItem.title = formatter.stringFromDate(NSDate())
        updatePreferences()
        updateDisplay()
    }
    
    func preferencesDidUpdate() {
        updateAll()
    }
    
    func updatePreferences() {
        let defaults = NSUserDefaults.standardUserDefaults()
        startDate = defaults.valueForKey("startDate") as? NSDate ?? DEFAULT_STARTDATE
        
        if let count = defaults.stringForKey("lastCount") {
            if let countNo = Int(count) {
                lastCount = countNo
            } else { lastCount = DEFAULT_LASTCOUNT }
        } else { lastCount = DEFAULT_LASTCOUNT }
        
        displayFormat = defaults.stringForKey("displayFormat") ?? DEFAULT_DISPLAYFORMAT
        
        if let size = defaults.stringForKey("fontSize") {
            if let sizeNo = Float(size) {
                fontSize = sizeNo
            } else { fontSize = DEFAULT_FONTSIZE }
        } else { fontSize = DEFAULT_FONTSIZE }
            
        sem = Semester.init(startDate: startDate, lastCount: lastCount)
    }
    
    func updateDisplay() {
        if let button = statusItem.button {
            button.attributedTitle = showWeekCount(sem.getWeekNo())
        }
    }
    
    func convertToChinese(count: Int) -> String {
        let hiDict = [0: "", 1: "十", 2: "二十", 3: "三十", 4: "四十", 5: "五十", 6: "六十", 7: "七十", 8: "八十", 9: "九十"]
        let loDict = [0: "", 1: "一", 2: "二", 3: "三", 4: "四", 5: "五", 6: "六", 7: "七", 8: "八", 9: "九"]
        guard (count > 0 && count < 100) else { return "" }
        let hi = count / 10
        let lo = count % 10
        return hiDict[hi]! + loDict[lo]!
    }
    
    func iso8601Format(var str: String) -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        let supportedStrings = ["YYYY", "YY", "Y", "yyyy", "yy", "y", "MM", "M", "dd", "d", "EEEE", "eeee", "HH", "H", "hh", "h", "mm", "m", "ss", "s"]
        for e in supportedStrings {
            formatter.dateFormat = e
            let convertedStr = formatter.stringFromDate(NSDate())
            str = str.stringByReplacingOccurrencesOfString(e, withString: convertedStr)
        }
        str = str.stringByReplacingOccurrencesOfString("星期", withString: "周")
        return str
    }
    
    func showWeekCount(count: Int) -> NSAttributedString {
        let font = NSFont.systemFontOfSize(CGFloat(fontSize))
        if count > 0 {
            var rawStr = displayFormat.stringByReplacingOccurrencesOfString("{W}", withString: String(count))
            rawStr = rawStr.stringByReplacingOccurrencesOfString("{zhW}", withString: convertToChinese(count))
            rawStr = iso8601Format(rawStr)
            return NSAttributedString.init(string: rawStr, attributes: [NSFontAttributeName: font])
        } else {
            return NSAttributedString.init(string: "WeekCount", attributes: [NSFontAttributeName: font])
        }
    }
}
