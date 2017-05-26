//
//  ClosureMenuItem.swift
//  SerialTyper
//
//  Created by Mattias Jähnke on 2017-05-21.
//  Copyright © 2017 Mattias Jähnke. All rights reserved.
//

import Cocoa

class ClosureMenuItem: NSMenuItem {
    var actionClosure: () -> ()
    init(title: String, keyEquivalent: String = "", action: @escaping () -> ()) {
        self.actionClosure = action
        super.init(title: title,
                   action: #selector(ClosureMenuItem.action(sender:)),
                   keyEquivalent: keyEquivalent)
        self.target = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action(sender: NSMenuItem) {
        self.actionClosure()
    }
}
