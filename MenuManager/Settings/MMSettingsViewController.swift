//
//  ViewController.swift
//  MenuManager
//
//  Created by Chuanbo Pan on 7/22/17.
//  Copyright © 2017 Chuanbo Pan. All rights reserved.
//

import Cocoa

class MMSettingsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    static let kReuseIdentifier = "DefaultCell"
    
    @IBOutlet weak var detailView: MMSettingsDetailView!
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: - NSTableView
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: MMSettingsViewController.kReuseIdentifier), owner: nil) as? NSTableCellView
        
        cell?.textField?.stringValue = "test"
        
        return cell
    }
    
}

