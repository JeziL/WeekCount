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
let DEFAULT_AUTOLAUNCH = NSOnState

class StatusMenuController: NSObject, PreferencesWindowDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    var preferencesWindow: PreferencesWindow!
    var startDate: NSDate!
    var lastCount: Int!
    var displayFormat: String!
    var fontSize: Float!
    var autoLaunch: Int!
    
    var sem: Semester!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
        
        //NSUserDefaults.standardUserDefaults().setPersistentDomain(["":""], forName: NSBundle.mainBundle().bundleIdentifier!)
        
        updatePreferences()
        updateDisplay()
        
        statusMenu.itemArray.last!.action = Selector("terminate:")
        statusItem.menu = statusMenu
        
    }
    
    @IBAction func showPreferencesWindow(sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    func preferencesDidUpdate() {
        updatePreferences()
        updateDisplay()
    }
    
    func updatePreferences() {
        let defaults = NSUserDefaults.standardUserDefaults()
        startDate = defaults.valueForKey("startDate") as? NSDate ?? DEFAULT_STARTDATE
        
        if let count = defaults.stringForKey("lastCount") {
            lastCount = Int(count)
        } else { lastCount = DEFAULT_LASTCOUNT }
        
        displayFormat = defaults.stringForKey("displayFormat") ?? DEFAULT_DISPLAYFORMAT
        
        if let size = defaults.stringForKey("fontSize") {
            fontSize = Float(size)
        } else { fontSize = DEFAULT_FONTSIZE }
        
        autoLaunch = defaults.valueForKey("autoLaunch") as? Int ?? DEFAULT_AUTOLAUNCH
        
        sem = Semester.init(startDate: startDate, lastCount: lastCount)
    }
    
    func updateDisplay() {
        if let button = statusItem.button {
            button.attributedTitle = showWeekCount(sem.getWeekNo())
        }
    }
    
    func showWeekCount(count: Int) -> NSAttributedString {
        let font = NSFont.systemFontOfSize(CGFloat(fontSize))
        if count > 0 {
            let rawStr = displayFormat.stringByReplacingOccurrencesOfString("{W}", withString: String(count))
            return NSAttributedString.init(string: rawStr, attributes: [NSFontAttributeName: font])
        } else {
            return NSAttributedString.init(string: "", attributes: [NSFontAttributeName: font])
        }
    }
}
