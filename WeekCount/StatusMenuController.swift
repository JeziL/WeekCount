//
//  StatusMenuController.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

let DEFAULT_STARTDATE = Date.init(timeIntervalSince1970: 1456099200)
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
    var startDate: Date!
    var lastCount: Int!
    var displayFormat: String!
    var fontSize: Float!
    var autoLaunch: Int!
    
    var sem: Semester!
    
    var statusItem: NSStatusItem!// = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        statusItem = NSStatusItem()._init(inStatusBar: NSStatusBar.system(), withLength: NSVariableStatusItemLength, withPriority: NSStatusBarItemPrioritySystem)
        
        preferencesWindow = PreferencesWindow()
        aboutWindow = AboutWindow()
        preferencesWindow.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(StatusMenuController.updateAll), name: NSNotification.Name(rawValue: "URLSchemesUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatusMenuController.showPreferencesWindow), name: NSNotification.Name(rawValue: "URLSchemesShowPreferences"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatusMenuController.quit), name: NSNotification.Name(rawValue: "URLSchemesQuit"), object: nil)
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StatusMenuController.updateAll), userInfo: nil, repeats: true)
        let loop = RunLoop.main
        loop.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        statusMenu.items.last!.action = #selector(StatusMenuController.quit)
        statusItem.menu = statusMenu
        
    }
    
    @IBAction func showPreferencesWindow(sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func showAboutWindow(sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        aboutWindow.showWindow(nil)
    }
    
    @IBAction func quitApp(_ sender: NSMenuItem) {
        quit()
    }
    
    func quit() {
        NSApplication.shared().terminate(self)
    }
    
    func resetPreferences() {
        UserDefaults.standard.setPersistentDomain(["":""], forName: Bundle.main.bundleIdentifier!)
        updateAll()
    }
    
    func updateAll() {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrent
        formatter.dateStyle = .full
        dateMenuItem.title = formatter.string(from: Date())
        updatePreferences()
        updateDisplay()
    }
    
    func preferencesDidUpdate() {
        updateAll()
    }
    
    func updatePreferences() {
        let defaults = UserDefaults.standard
        startDate = defaults.value(forKey: "startDate") as? Date ?? DEFAULT_STARTDATE
        
        if let count = defaults.string(forKey: "lastCount") {
            if let countNo = Int(count) {
                lastCount = countNo
            } else { lastCount = DEFAULT_LASTCOUNT }
        } else { lastCount = DEFAULT_LASTCOUNT }
        
        displayFormat = defaults.string(forKey: "displayFormat") ?? DEFAULT_DISPLAYFORMAT
        
        if let size = defaults.string(forKey: "fontSize") {
            if let sizeNo = Float(size) {
                fontSize = sizeNo
            } else { fontSize = DEFAULT_FONTSIZE }
        } else { fontSize = DEFAULT_FONTSIZE }
            
        sem = Semester.init(startDate: startDate, lastCount: lastCount)
    }
    
    func updateDisplay() {
        if let button = statusItem.button {
            button.attributedTitle = showWeekCount(count: sem.getWeekNo())
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
    
    func iso8601Format(str: String) -> String {
        var str = str
        let formatter = DateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrent
        let supportedStrings = ["YYYY", "YY", "Y", "yyyy", "yy", "y", "MM", "M", "dd", "d", "EEEE", "eeee", "HH", "H", "hh", "h", "mm", "m", "ss", "s"]
        for e in supportedStrings {
            formatter.dateFormat = e
            let convertedStr = formatter.string(from: Date())
            str = str.replacingOccurrences(of: e, with: convertedStr)
        }
        str = str.replacingOccurrences(of: "星期", with: "周")
        return str
    }
    
    func showWeekCount(count: Int) -> NSAttributedString {
        let font = NSFont.systemFont(ofSize: CGFloat(fontSize))
        if count > 0 {
            var rawStr = displayFormat.replacingOccurrences(of: "{W}", with: String(count))
            rawStr = rawStr.replacingOccurrences(of: "{zhW}", with: convertToChinese(count: count))
            rawStr = iso8601Format(str: rawStr)
            return NSAttributedString.init(string: rawStr, attributes: [NSFontAttributeName: font])
        } else {
            return NSAttributedString.init(string: "WeekCount", attributes: [NSFontAttributeName: font])
        }
    }
}
