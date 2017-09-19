//
//  SharedUtilities.swift
//  MenuManager
//
//  Created by Chuanbo Pan on 9/11/17.
//  Copyright © 2017 Chuanbo Pan. All rights reserved.
//

import Cocoa

class SharedUtilities {
    
    // MARK: - Folder Selection
    
    static public func selectFolder(_ completion:@escaping (String?) -> Void) {
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            let openPanel = NSOpenPanel();
            openPanel.title = "Select a directory"
            openPanel.showsResizeIndicator = true
            openPanel.canChooseDirectories = true
            openPanel.canChooseFiles = false
            openPanel.allowsMultipleSelection = false
            openPanel.canCreateDirectories = true
            
            openPanel.begin { (result) in
                if (result.rawValue == NSFileHandlingPanelOKButton) {
                    if let path = openPanel.url?.path {
                        completion(path)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Text Input
    
    static public func textInput(_ completion:@escaping (String?) -> Void) {
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            let alert = NSAlert()
            alert.messageText = "Input"
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            
            let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
            input.stringValue = ""
            alert.accessoryView = input
            
            alert.window.initialFirstResponder = input
            let res = alert.runModal()
            
            if res == .alertFirstButtonReturn { completion(input.stringValue) }
            else { completion(nil) }
        }
    }
}
