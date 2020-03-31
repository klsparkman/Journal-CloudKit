//
//  EntryListTableViewController.swift
//  Journal-CloudKit
//
//  Created by Kelsey Sparkman on 3/30/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.sharedInstance.fetchEntries { (result) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        EntryController.sharedInstance.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let entry = EntryController.sharedInstance.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        //cell.detailTextLabel?.text = entry.timestamp.formatDate()

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditEntry" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? EntryDetailViewController else {return}
            
            let entryToSend = EntryController.sharedInstance.entries[indexPath.row]
            destinationVC.entry = entryToSend
        }
    }
}
