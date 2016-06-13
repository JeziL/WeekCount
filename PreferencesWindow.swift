//
//  PreferencesWindow.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

import Cocoa

class PreferencesWindow: NSWindowController, NSWindowDelegate {

    @IBOutlet var startDatePicker: NSDatePicker!
    @IBOutlet var lastCountField: NSTextField!
    @IBAction func stepperClicked(sender: NSStepper) {
        lastCountField.stringValue = "\(sender.intValue)"
    }
    @IBOutlet var displayFormatField: NSTextField!
    @IBOutlet var autoLaunchButton: NSButton!
    
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName: String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        startDatePicker.dateValue = defaults.valueForKey("startDate") as? NSDate ?? DEFAULT_STARTDATE
        lastCountField.stringValue = defaults.stringForKey("lastCount") ?? String(DEFAULT_LASTCOUNT)
        displayFormatField.stringValue = defaults.stringForKey("displayFormat") ?? DEFAULT_DISPLAYFORMAT
        autoLaunchButton.state = defaults.valueForKey("autoLaunch") as? Int ?? DEFAULT_AUTOLAUNCH
    }
    
    func windowWillClose(notification: NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(startDatePicker.dateValue, forKey: "startDate")
        defaults.setValue(lastCountField.stringValue, forKey: "lastCount")
        defaults.setValue(displayFormatField.stringValue, forKey: "displayFormat")
        defaults.setValue(autoLaunchButton.state, forKey: "autoLaunch")
        
        defaults.synchronize()
        
        delegate?.preferencesDidUpdate()
    }
    
}
