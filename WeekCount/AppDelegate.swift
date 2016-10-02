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
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.receiveURLSchemes(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    func receiveURLSchemes(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let urlStr = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue {
            if let url = NSURL(string: urlStr) {
                handleURLScheme(url: url)
            }
        }
    }
    
    func handleURLScheme(url: NSURL) {
        if url.host != nil {
            switch (url.host!) {
                case "reset":
                    UserDefaults.standard.setPersistentDomain(["":""], forName: Bundle.main.bundleIdentifier!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "URLSchemesUpdate"), object: nil)
                case "set":
                    if url.query != nil {
                        let urlComponents = NSURLComponents(url: url as URL, resolvingAgainstBaseURL: true)
                        let queryItems = urlComponents?.queryItems
                        let startDate = queryItems?.filter({$0.name == "startDate"}).first
                        let lastCount = queryItems?.filter({$0.name == "lastCount"}).first
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyMMdd"
                        
                        if let dateStr = startDate?.value {
                            if let date = formatter.date(from: dateStr) {
                                UserDefaults.standard.setValue(date, forKey: "startDate")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "URLSchemesUpdate"), object: nil)
                            }
                        }
                        if let lastStr = lastCount?.value {
                            if let last = Int(lastStr) {
                                UserDefaults.standard.setValue(String(last), forKey: "lastCount")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "URLSchemesUpdate"), object: nil)
                            }
                        }
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "URLSchemesShowPreferences"), object: nil)
                    }
                case "quit":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "URLSchemesQuit"), object: nil)
                default:()
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "URLSchemesShowPreferences"), object: nil)
        }
    }
}

