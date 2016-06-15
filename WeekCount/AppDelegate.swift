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
            }
        }
    }
    
    func handleURLScheme(url: NSURL) {
        if url.host != nil {
            switch (url.host!) {
                case "reset":
                    NSUserDefaults.standardUserDefaults().setPersistentDomain(["":""], forName: NSBundle.mainBundle().bundleIdentifier!)
                    NSNotificationCenter.defaultCenter().postNotificationName("URLSchemesUpdate", object: nil)
                case "set":
                    if url.query != nil {
                        let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
                        let queryItems = urlComponents?.queryItems
                        let startDate = queryItems?.filter({$0.name == "startDate"}).first
                        let lastCount = queryItems?.filter({$0.name == "lastCount"}).first
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyyMMdd"
                        
                        if let dateStr = startDate?.value {
                            if let date = formatter.dateFromString(dateStr) {
                                NSUserDefaults.standardUserDefaults().setValue(date, forKey: "startDate")
                                NSNotificationCenter.defaultCenter().postNotificationName("URLSchemesUpdate", object: nil)
                            }
                        }
                        if let lastStr = lastCount?.value {
                            if let last = Int(lastStr) {
                                NSUserDefaults.standardUserDefaults().setValue(String(last), forKey: "lastCount")
                                NSNotificationCenter.defaultCenter().postNotificationName("URLSchemesUpdate", object: nil)
                            }
                        }
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName("URLSchemesShowPreferences", object: nil)
                    }
                case "quit":
                    NSNotificationCenter.defaultCenter().postNotificationName("URLSchemesQuit", object: nil)
                default:()
            }
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("URLSchemesShowPreferences", object: nil)
        }
    }
}

