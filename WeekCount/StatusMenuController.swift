//
//  StatusMenuController.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!
    var preferencesWindow: PreferencesWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        
        preferencesWindow = PreferencesWindow()
        
        if let button = statusItem.button {
            button.title = "TEST"
        }
        
        statusMenu.itemArray.last!.action = Selector("terminate:")
        statusItem.menu = statusMenu
        
    }
    
    @IBAction func showPreferencesWindow(sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
}
