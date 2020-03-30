//
//  Entry.swift
//  Journal-CloudKit
//
//  Created by Kelsey Sparkman on 3/30/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import CloudKit

struct EntryConstants {
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimestampKey = "timestamp"
}

class Entry {
    
    let title: String
    let body: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.TitleKey] as? String,
        let body = ckRecord[EntryConstants.BodyKey] as? String,
        let timestamp = ckRecord[EntryConstants.TimestampKey] as? Date else {return nil}
        
        self.init(title: title, body: body, timestamp: timestamp)
    }
}

