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

class PreferencesWindow: NSWindowController, NSWindowDelegate, NSTextFieldDelegate {

    @IBOutlet var startDatePicker: NSDatePicker!
    @IBOutlet var lastCountField: NSTextField!
    @IBOutlet var lastStepper: NSStepper!
    @IBAction func stepperClicked(sender: NSStepper) {
        lastCountField.stringValue = "\(sender.intValue)"
    }
    @IBOutlet var displayFormatField: NSTextField!
    @IBOutlet var fontSizeStepper: NSStepper!
    @IBAction func fontSizeStepperClicked(sender: NSStepper) {
        fontSizeField.stringValue = "\(sender.floatValue)"
        NSUserDefaults.standardUserDefaults().setValue(fontSizeField.stringValue, forKey: "fontSize")
        delegate?.preferencesDidUpdate()
    }
    @IBOutlet var fontSizeField: NSTextField!
    
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName: String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        lastCountField.delegate = self
        fontSizeField.delegate = self
        displayFormatField.delegate = self
        
        displayPreferences()
    }
    
    func windowDidBecomeKey(notification: NSNotification) {
        displayPreferences()
    }
    
    func displayPreferences() {
        let defaults = NSUserDefaults.standardUserDefaults()
        startDatePicker.dateValue = defaults.valueForKey("startDate") as? NSDate ?? DEFAULT_STARTDATE
        lastCountField.stringValue = defaults.stringForKey("lastCount") ?? String(DEFAULT_LASTCOUNT)
        displayFormatField.stringValue = defaults.stringForKey("displayFormat") ?? DEFAULT_DISPLAYFORMAT
        fontSizeField.stringValue = defaults.stringForKey("fontSize") ?? String(DEFAULT_FONTSIZE)
        
        lastStepper.intValue = lastCountField.intValue
        fontSizeStepper.floatValue = fontSizeField.floatValue
    }
    
    
    override func controlTextDidChange(notification: NSNotification) {
        let object = notification.object as! NSTextField
        if object.tag == 15 {
            fontSizeStepper.floatValue = object.floatValue
        }
        updatePreferences()
    }
    
    func windowWillClose(notification: NSNotification) {
        updatePreferences()
    }
    
    func updatePreferences() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(startDatePicker.dateValue, forKey: "startDate")
        if Int(lastCountField.stringValue) != nil {
            defaults.setValue(lastCountField.stringValue, forKey: "lastCount")
        }
        defaults.setValue(displayFormatField.stringValue, forKey: "displayFormat")
        if Float(fontSizeField.stringValue) != nil {
            defaults.setValue(fontSizeField.stringValue, forKey: "fontSize")
        }
        defaults.synchronize()
        
        delegate?.preferencesDidUpdate()
    }
    
}
