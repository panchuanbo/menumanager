//
//  MMSettingsDetailView.swift
//  MenuManager
//
//  Created by Chuanbo Pan on 9/18/17.
//  Copyright © 2017 Chuanbo Pan. All rights reserved.
//

import Cocoa

protocol MMSettingsDetailViewDelegate: class {
    
}

class MMSettingsDetailView: NSBox {
    
    // MARK: - Constants
    
    private let kSeparator = "e2be7b4f-f708-490a-8a12-55344837e6b3"
    private let kSelectColor = NSColor(red: 220.0/255.0, green: 237.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    // MARK: - Delegate
    
    weak var delegate: MMSettingsDetailViewDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var _titleTextField: NSTextField!
    @IBOutlet private weak var _launchPathTextField: NSTextField!
    @IBOutlet private weak var _commandListTextField: NSTextField!
    
    @IBOutlet private weak var _bashCButton: NSButton!
    
    // MARK: - Variables
    
    private var _rawCommands = ""
    private var _currentConfiguration = BashTaskSettings(name: "", launchPath: "", params: nil, useBashC: false)
    
    // MARK: - Initialization
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    // MARK: - Save Changes
    
    @IBAction private func _save(_ sender: AnyObject) {
        if let _ = self.delegate {
            
        }
    }
    
    // MARK: - Configure Command with highlighting
    
    private func _convertParamListToAttributedString() -> NSAttributedString {
        guard let params = _currentConfiguration.params, params.count > 0 else { return NSAttributedString() }
        
        let mutableAttributedString = NSMutableAttributedString()
        let space = NSAttributedString(string: " ", attributes: [.backgroundColor : NSColor.white])
        
        for param in params {
            let tag = NSAttributedString(string: param, attributes: [.backgroundColor : kSelectColor])
            mutableAttributedString.append(tag)
            mutableAttributedString.append(space)
        }
        
        return mutableAttributedString
    }
    
    @IBAction private func _didPressEnter(_ sender: NSTextField) {

        if let concat = _currentConfiguration.concatParams(), let loc = sender.attributedStringValue.string.range(of: concat) {
            let newCommandSubSeq = sender.attributedStringValue.string[loc.upperBound...]
            let newCommand = newCommandSubSeq.trimmingCharacters(in: .whitespacesAndNewlines)
            _currentConfiguration.params?.append(newCommand)
        } else {
            _currentConfiguration.params = [sender.attributedStringValue.string]
        }
        
        _commandListTextField.attributedStringValue = _convertParamListToAttributedString()
    }
    
    // MARK: - Configure Box
    
    public func configure(_ settings: BashTaskSettings) {
        
    }
    
    // MARK: - NSTextFieldDelegate
    
}
