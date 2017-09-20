//
//  BashTaskSettings.swift
//  MenuManager
//
//  Created by Chuanbo Pan on 9/11/17.
//  Copyright © 2017 Chuanbo Pan. All rights reserved.
//

import Cocoa

struct BashTaskSettings {
    var name: String!
    var launchPath: String!
    var params: [String]?
    var useBashC: Bool!
    var UUID: String!
    
    init(name: String, launchPath: String, params: [String]?, useBashC: Bool) {
        self.name = name
        self.launchPath = launchPath
        self.params = params
        self.useBashC = useBashC
    }
    
    func concatParams(_ separator: String = " ") -> String? {
        guard let p = self.params, p.count > 0 else { return nil }
        
        return p.joined(separator: " ")
    }
}
