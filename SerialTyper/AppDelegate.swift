//
//  AppDelegate.swift
//  SerialTyper
//
//  Created by Mattias Jähnke on 2017-05-21.
//  Copyright © 2017 Mattias Jähnke. All rights reserved.
//

import Cocoa

var terminateAppOnSerialClose = false

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            let alert = NSAlert()
            alert.messageText = "SerialTyper"
            alert.informativeText = "You need to enable accessibility for SerialTyper (see dialog behind this one) in System Preferences and launch this app again."
            alert.addButton(withTitle: "OK")
            alert.runModal()
            NSApp.terminate(self)
        }
        
        // Listen for serial port close
        // This workaround aims to fix a problem with kernel panics when terminating the app
        NotificationCenter.default.addObservers(forNames: .serialPortClosed) { _ in
            guard terminateAppOnSerialClose else { return }
            NSApp.terminate(self)
        }
    }
}
