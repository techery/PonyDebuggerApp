//
//  ViewController.swift
//  PonyDebugger
//
//  Created by Eugene on 10/25/15.
//  Copyright © 2015 FocusedGenius. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var outputLabel : NSTextField?
    @IBOutlet var runButton : NSButton?
    @IBOutlet var stopButton : NSButton?
    
    private var ponyDebugger = PonyDebugger()
    private var ipAddress : String?
    
    deinit {
        ponyDebugger.stopPonyDebugger()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ipAddress = getIPAddresses().first
        guard (ipAddress != nil) else {
            return;
        }
        outputLabel?.stringValue = "Your IP: \(ipAddress!)";
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction private func runScriptButtonPressed(sender : AnyObject) {
        guard (ipAddress != nil) else {
            return;
        }
        ponyDebugger.startPonyDebugger(ipAddress)
        
        runButton?.enabled = false
        stopButton?.enabled = true
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC)), dispatch_get_main_queue()){
            if let url = NSURL(string: "http://\(self.ipAddress!):9000") {
                NSWorkspace.sharedWorkspace().openURL(url)
            }
        }
    }

    @IBAction private func stopButtonPressed(sender : AnyObject) {
        ponyDebugger.stopPonyDebugger()
        
        runButton?.enabled = true
        stopButton?.enabled = false
    }
}

