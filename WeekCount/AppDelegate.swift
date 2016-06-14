//
//  AppDelegate.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSAppleEventManager.sharedAppleEventManager().setEventHandler(self, andSelector: Selector("receiveURLSchemes:replyEvent:"), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    func receiveURLSchemes(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let urlStr = event?.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
            if let url = NSURL(string: urlStr) {
                handleURLScheme(url)
                NSNotificationCenter.defaultCenter().postNotificationName("URLSchemesReceived", object: nil)
            }
        }
    }
    
    func handleURLScheme(url: NSURL) {
        if url.host != nil {
            switch (url.host!) {
                case "reset":
                    NSUserDefaults.standardUserDefaults().setPersistentDomain(["":""], forName: NSBundle.mainBundle().bundleIdentifier!)
            default:()
            }
        }
    }
}

