//
//  AboutWindow.swift
//  WeekCount
//
//  Created by Li on 16/6/20.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

class AboutWindow: NSWindowController, NSWindowDelegate {

    @IBOutlet var versionLabel: NSTextField!
    
    @IBAction func gitHubButtonClicked(sender: NSButton) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://github.com/JeziL/WeekCount")!)
    }
    
    @IBAction func mailButtonClicked(sender: NSButton) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "mailto:hi@wangjinli.com")!)
    }
    
    override var windowNibName: String! {
        return "AboutWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        NSApp.activateIgnoringOtherApps(true)
    }
    
    func windowDidBecomeKey(notification: NSNotification) {
        versionLabel.stringValue = "v" + (NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)
    }
    
}
