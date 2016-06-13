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
let DEFAULT_AUTOLAUNCH = NSOnState

class StatusMenuController: NSObject, PreferencesWindowDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    var preferencesWindow: PreferencesWindow!
    var startDate: NSDate!
    var lastCount: Int!
    var displayFormat: String!
    var autoLaunch: Int!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
        
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
        lastCount = Int(defaults.stringForKey("lastCount")!) ?? DEFAULT_LASTCOUNT
        displayFormat = defaults.stringForKey("displayFormat") ?? DEFAULT_DISPLAYFORMAT
        autoLaunch = defaults.valueForKey("autoLaunch") as? Int ?? DEFAULT_AUTOLAUNCH
    }
    
    func updateDisplay() {
        if let button = statusItem.button {
            button.title = displayFormat
        }
    }
}
