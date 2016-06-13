//
//  PreferencesWindow.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController, NSWindowDelegate {

    override var windowNibName: String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
    }
    
}
