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
        NSWorkspace.shared().open(URL(string: "https://github.com/JeziL/WeekCount")!)
    }
    
    @IBAction func mailButtonClicked(sender: NSButton) {
        NSWorkspace.shared().open(URL(string: "mailto:hi@wangjinli.com")!)
    }
    
    override var windowNibName: String! {
        return "AboutWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        versionLabel.stringValue = "v" + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
    }
    
    
}
