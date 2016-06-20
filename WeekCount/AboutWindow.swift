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
    
    override var windowNibName: String! {
        return "AboutWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
    }
    
    func windowDidBecomeKey(notification: NSNotification) {
        versionLabel.stringValue = "v" + (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)
    }
    
}
