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
    @IBOutlet weak var copyrightLabel: NSTextField!
    
    @IBAction func gitHubButtonClicked(sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "https://github.com/JeziL/WeekCount")!)
    }
    
    @IBAction func mailButtonClicked(sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "mailto:hi@wangjinli.com")!)
    }
    
    override var windowNibName: NSNib.Name! {
        return NSNib.Name.init("AboutWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        versionLabel.stringValue = "v" + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let currentYear = formatter.string(from: Date())
        copyrightLabel.stringValue = "Copyright © 2016-\(currentYear) Jinli Wang.\nAll rights reserved."
    }
    
    
}
