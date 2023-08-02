//
//  Bundle+Ext.swift
//  AllerView
//
//  Created by 조기연 on 2023/08/03.
//

import Foundation

extension Bundle {
    var freeAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
            fatalError("Couldn't find file 'SecretKey.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)

        guard let value = plist?.object(forKey: "FreeAPIKey") as? String else {
            fatalError("Couldn't find key 'FreeAPIKey' in 'SecretKey.plist'.")
        }
        return value
    }
}
