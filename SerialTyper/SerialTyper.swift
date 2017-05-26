//
//  SerialTyper.swift
//  SerialTyper
//
//  Created by Mattias Jähnke on 2017-05-21.
//  Copyright © 2017 Mattias Jähnke. All rights reserved.
//

import Cocoa
import ORSSerial

extension NSNotification.Name {
    static let serialPortClosed = Notification.Name("SerialPortClosed")
}

class SerialTyper: NSObject {
    
    fileprivate var serialPort: ORSSerialPort?
    @IBOutlet weak var menuHandler: MenuHandler!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("Application is \(AXIsProcessTrusted() ? "trused" : "not trused")")
        guard AXIsProcessTrusted() else { return }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let s = self, let serialPort = s.serialPort else { return }
            serialPort.send(event: event)
        }
        
        menuHandler.connect = { [weak self] path, baudRate in
            guard let s = self else { return }
            
            s.serialPort = ORSSerialPort(path: path)
            s.serialPort!.baudRate = NSNumber(value: baudRate)
            
            s.serialPort!.delegate = self
            s.serialPort!.open()
        }
        
        menuHandler.disconnect = { [weak self] in
            guard let s = self else { return }
            
            if let serialPort = s.serialPort, serialPort.isOpen {
                serialPort.close()
            } else if terminateAppOnSerialClose {
                NSApp.terminate(self)
            }
        }
    }
}

extension SerialTyper: ORSSerialPortDelegate {
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        guard let text = String(data: data, encoding: .utf8) else { return }
        print("Recieved: \(text)")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("Serial port (\(serialPort)) encountered error: \(error.localizedDescription)")
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        NotificationCenter.default.post(name: .serialPortClosed, object: nil)
    }
}

private extension ORSSerialPort {
    func send(event: NSEvent) {
        guard let string = event.charactersIgnoringModifiers, !string.isEmpty else { return }
        guard let ascii = string.characters.first!.asciiValue else { return }
        var input = ascii
        let data = withUnsafePointer(to: &input) { Data(bytes: UnsafePointer($0), count: MemoryLayout.size(ofValue: ascii)) }
        send(data)
    }
}

private extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}
