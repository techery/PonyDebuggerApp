//
//  PonyDebugger.swift
//  PonyDebugger
//
//  Created by Eugene on 10/25/15.
//  Copyright © 2015 FocusedGenius. All rights reserved.
//

import Foundation

struct PonyDebugger {
    var isRunning : Bool = false
    private var ponyTask : NSTask?
    private let ponyQueue = dispatch_queue_create(
        "io.focusedgenius.ponyQueue", DISPATCH_QUEUE_CONCURRENT)
    
    mutating func startPonyDebugger(interface:String?) {
        if (isRunning) {
            return;
        }
        
        self.ponyTask = NSTask()
        dispatch_async(ponyQueue) {
            var input : String
            if let inputInterface = interface {
                input = "/usr/local/bin/ponyd serve --listen-interface=" + inputInterface
            }
            else {
                input = "/usr/local/bin/ponyd serve"
            }
            let arguments : [String] = input.characters.split { $0 == " " }.map(String.init)
            
            self.ponyTask!.launchPath = "/usr/bin/env"
            self.ponyTask!.arguments = arguments
            self.ponyTask!.environment = [
                "LC_ALL" : "en_US.UTF-8",
                "HOME" : NSHomeDirectory()
            ]
            
            let pipe = NSPipe()
            self.ponyTask!.standardOutput = pipe
            self.ponyTask!.launch()
            self.ponyTask!.waitUntilExit()
        }
        isRunning = true
    }
    
    mutating func stopPonyDebugger() {
        if (!isRunning) {
            return;
        }
        dispatch_async(ponyQueue) {
            let systemString = "kill -9 " + String(self.ponyTask!.processIdentifier)
            system(systemString)
            self.ponyTask?.interrupt()
            self.ponyTask = nil
        }
        isRunning = false
    }
}