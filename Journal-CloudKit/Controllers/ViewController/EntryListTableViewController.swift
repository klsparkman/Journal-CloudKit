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
            self.updateViews()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = EntryController.sharedInstance.entries[indexPath.row]
            EntryController.sharedInstance.remove(entry: entryToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
    }
    }
}
