//
//  AppDelegate.swift
//  MenuManager
//
//  Created by Chuanbo Pan on 7/22/17.
//  Copyright © 2017 Chuanbo Pan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSOpenSavePanelDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    let menu = NSMenu()
    
    let quitAppMenuItem = NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q")
    let settingsAppMenuItem = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "")
    
    var bashMenuItems: [BashTaskManager] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = #imageLiteral(resourceName: "menu-icon")
        }
        
        statusItem.menu = menu
        
        setupMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // mark: - Setup Jupyter
    
    func setupMenu() {
        // TODO: Make this modular
        let settings = BashTaskSettings(name: "Jupyter Notebook", launchPath: "/usr/local/bin/jupyter", params: ["notebook", "{dir}"], useBashC: false)
        bashMenuItems.append(BashTaskManager(settings))
        
        let sleepSettings = BashTaskSettings(name: "Open", launchPath: "/usr/bin/open", params: ["{input}"], useBashC: true)
        bashMenuItems.append(BashTaskManager(sleepSettings))
        
        
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(settingsAppMenuItem)
        menu.addItem(quitAppMenuItem)
        
        menu.autoenablesItems = false
    }

    // mark: - Status Bar
    
    func openSettings() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let settingsWindowController = storyboard.instantiateController(withIdentifier: "SettingsMenu") as! NSWindowController
        
        if let settingsWindow = settingsWindowController.window {
            NSApplication.shared().runModal(for: settingsWindow)
        }
    }
    
    func terminate() {
        NSApplication.shared().terminate(self)
    }
}

