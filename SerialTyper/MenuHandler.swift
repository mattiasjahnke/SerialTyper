//
//  MenuHandler.swift
//  SerialTyper
//
//  Created by Mattias Jähnke on 2017-05-21.
//  Copyright © 2017 Mattias Jähnke. All rights reserved.
//

import Cocoa
import ORSSerial
import ObjectiveC

class MenuHandler: NSObject {
    
    private let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var portMenuItem: NSMenuItem!
    @IBOutlet weak var availablePortsMenu: NSMenu!
    @IBOutlet weak var baudRateMenuItem: NSMenuItem!
    @IBOutlet weak var availableBaudRateMenu: NSMenu!
    
    var connect: ((String, Int) -> ())? {
        didSet {
            guard let _ = connect else { return }
            tryConnect()
        }
    }
    
    var disconnect: (() -> ())?
    
    private var selectedPath: String? {
        didSet {
            if let path = selectedPath {
                portMenuItem.title = "Port: \(path)"
                UserDefaults.standard.set(path, forKey: "lastPath")
            } else {
                portMenuItem.title = "Select port"
            }
            
            tryConnect()
        }
    }
    
    private var selectedBaudRate: Int? {
        didSet {
            if let rate = selectedBaudRate {
                baudRateMenuItem.title = "Baud rate: \(rate)"
                UserDefaults.standard.set("\(rate)", forKey: "lastBaudRate")
            } else {
                baudRateMenuItem.title = "Select Baud rate"
            }

            tryConnect()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        portMenuItem.title = "Port (N/A)"
        
        // Setup the baud rates
        availableBaudRateMenu.removeAllItems()
        for port in [0, 50, 75, 110, 134, 150, 200,
                     300, 600, 1200, 2400, 4800, 9600,
                     19200, 38400, 7200, 14400, 2880,
                     57600, 768, 115200, 230400] {
            let item = ClosureMenuItem(title: "\(port)", keyEquivalent: "") { [weak self] in
                self?.selectedBaudRate = port
            }
            availableBaudRateMenu.addItem(item)
        }
        
        NotificationCenter.default.addObservers(forNames: .ORSSerialPortsWereConnected,
                                                .ORSSerialPortsWereDisconnected) { _ in
            self.updatePortList()
        }
        
        updatePortList()

        // Check the last used settings
        if let lastUsedPort = UserDefaults.standard.string(forKey: "lastPath") {
            if !availablePortsMenu.items.filter ({ $0.title == lastUsedPort }).isEmpty {
                selectedPath = lastUsedPort
            }
        }
        
        if let lastBaudRate = UserDefaults.standard.string(forKey: "lastBaudRate") {
            if !availableBaudRateMenu.items.filter ({ $0.title == lastBaudRate }).isEmpty {
                selectedBaudRate = Int(lastBaudRate)
            }
        }
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        terminateAppOnSerialClose = true
        disconnect?()
    }
    
    /// Updates the list of Ports in the menu
    private func updatePortList() {
        availablePortsMenu.removeAllItems()
        for port in ORSSerialPortManager.shared().availablePorts {
            let item = ClosureMenuItem(title: port.path) { [weak self] in
                self?.selectedPath = port.path
            }
            availablePortsMenu.addItem(item)
        }
    }
    
    /// Calls the connect-closure if both selectedPath and selectedBaudRate are set
    private func tryConnect() {
        guard let connect = self.connect else { return }
        guard let selectedPath = selectedPath, let selectedBaudRate = selectedBaudRate else { return }
        connect(selectedPath, selectedBaudRate)
    }
}

extension NotificationCenter {
    @discardableResult
    func addObservers(forNames: NSNotification.Name..., object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> ()) -> [NSObjectProtocol] {
        return forNames.map { self.addObserver(forName: $0, object: object, queue: queue, using: block) }
    }
}
