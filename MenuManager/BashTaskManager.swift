//
//  BashTaskManager.swift
//  MenuManager
//
//  Created by Chuanbo Pan on 7/23/17.
//  Copyright © 2017 Chuanbo Pan. All rights reserved.
//

import Cocoa

class BashTaskManager: NSObject, NSOpenSavePanelDelegate {

    // delegate
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    // menu bar
    var statusItem: NSStatusItem!
    
    // process
    var process: Process?
    var stdOut: Pipe?
    var stdIn: Pipe?
    var stdErr: Pipe?
    
    // primary menu item
    var primaryMenuItem: NSMenuItem!
    
    // task specific menu
    let menu = NSMenu()
    
    // task specific menu items
    var launchProcessMenuItem: NSMenuItem!
    var terminateProcessMenuItem: NSMenuItem!
    
    // bash task settings
    var settings: BashTaskSettings!
    
    // serial queue
    var processDispatcher: DispatchQueue!
    
    override init() {
        super.init()
        
        statusItem = self.appDelegate.statusItem
    }
    
    convenience init(_ settings: BashTaskSettings) {
        self.init()
        
        self.settings = settings
        self.settings.UUID = UUID.init().uuidString
        
        self.setup()
        
        self.processDispatcher = DispatchQueue(label: self.settings.UUID)
    }
    
    private func setup() {
        self.menu.autoenablesItems = false
        
        self.primaryMenuItem = NSMenuItem(title: settings.name, action: nil, keyEquivalent: "")
        self.primaryMenuItem.submenu = menu
        self.primaryMenuItem.target = self
        self.primaryMenuItem.image = #imageLiteral(resourceName: "red-circle")
        
        self.launchProcessMenuItem = NSMenuItem(title: "Launch \(settings.name!)", action: #selector(BashTaskManager.launchProcess), keyEquivalent: "")
        self.terminateProcessMenuItem = NSMenuItem(title: "Terminate \(settings.name!)", action: #selector(BashTaskManager.terminateProcess), keyEquivalent: "")
        
        self.launchProcessMenuItem.target = self
        self.terminateProcessMenuItem.target = self
        
        self.launchProcessMenuItem.isEnabled = true
        self.terminateProcessMenuItem.isEnabled = false
        
        self.menu.addItem(self.launchProcessMenuItem)
        self.menu.addItem(self.terminateProcessMenuItem)
        
        self.statusItem.menu?.addItem(self.primaryMenuItem)
    }
    
    // MARK: - Launch/Terminate
    
    @objc private func launchProcess() {
        self.processDispatcher.async {
            var params: [String] = []
            if self.settings.params != nil { params = self.settings.params! }
            
            let semaphore = DispatchSemaphore(value: 0)
            
            var canceled = false
            
            for i in 0 ..< params.count {
                if params[i] == "{dir}" {
                    SharedUtilities.selectFolder({ (dir) in
                        if dir != nil { params[i] = dir! }
                        else { canceled = true }
                        semaphore.signal()
                    })
                    semaphore.wait()
                } else if params[i] == "{input}" {
                    SharedUtilities.textInput({ (input) in
                        if input != nil { params[i] = input! }
                        else { canceled = true }
                        semaphore.signal()
                    })
                    semaphore.wait()
                }
                
                if canceled { return }
            }
            
            
            var launchPath: String!
            
            if self.settings.useBashC {
                launchPath = "/bin/bash"
                let concatString = "\(self.settings.launchPath!) \(params.joined(separator: " "))"
                params = ["-c", concatString]
            } else {
                launchPath = self.settings.launchPath
            }
            
            self.process = Process()
            self.process!.launchPath = launchPath!
            self.process!.arguments = params
            
            self.process!.launch()
            
            self.launchProcessMenuItem.isEnabled = false
            self.terminateProcessMenuItem.isEnabled = true
            self.primaryMenuItem.image = #imageLiteral(resourceName: "green-circle")
            
            self.process?.waitUntilExit()
            self.cleanup()
        }
    }
    
    @objc private func terminateProcess() {
        if self.process != nil {
            self.process?.terminate()
            self.process?.waitUntilExit()
            self.cleanup()
        }
    }
    
    private func cleanup() {
        print("terminated!")
        self.process = nil
        self.launchProcessMenuItem.isEnabled = true
        self.terminateProcessMenuItem.isEnabled = false
        self.primaryMenuItem.image = #imageLiteral(resourceName: "red-circle")
    }
}
