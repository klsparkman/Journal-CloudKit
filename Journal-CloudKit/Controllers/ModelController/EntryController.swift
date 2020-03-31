//
//  EntryController.swift
//  Journal-CloudKit
//
//  Created by Kelsey Sparkman on 3/30/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import CloudKit

class EntryController {
    
    //Source of Truth
    var entries: [Entry] = []
    static let sharedInstance = EntryController()
    let privateDB = CKContainer.default().privateCloudDatabase
    
    
    // Mark: - CRUD
    func createEntry(with title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        save(entry: newEntry, completion: completion)
    }
    
    func save(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
            guard let record = record,
            let savedEntry = Entry(ckRecord: record)
                else { completion(.failure(.couldNotUnwrap)); return }
            print("New Entry saved successfully")
            self.entries.insert(savedEntry, at: 0)
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntries(with completion: @escaping(_ result: Result<[Entry]?, EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrown(error)))
            }
            guard let records = records else { completion(.failure(.couldNotUnwrap)); return }
            print("Successfully fetched all Entries")
            let entries = records.compactMap({ Entry(ckRecord: $0)})
            self.entries = entries
            completion(.success(entries))
            
        }
    }
    
}//End of Class

extension EntryController {
    enum EntryError: LocalizedError {
        case invalidURL
        case noData
        case thrown(Error)
        case failedToDelete
        case couldNotUnwrap
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Unable to reach DevMountain API."
            case .noData:
                return "The server responded with no data."
            case .thrown(let error):
                return error.localizedDescription
            case .failedToDelete:
                return "Unable to delete resource from the server."
            case .couldNotUnwrap:
                return "Could not unwrap data."
            }
        }
    }
}
