//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by jdcorn on 11/15/19.
//  Copyright © 2019 jdcorn. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func newItemButtonTapped(_ sender: UIBarButtonItem) {
        // Create the notification window
        let alert = UIAlertController(title: "Add Item", message: "Add an item to the list", preferredStyle: .alert)
        // Create text field
        alert.addTextField(configurationHandler: nil)
        // Create the 'cancel' button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Create the 'add' button
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            // Guarding against an empty value
            guard let itemName = alert.textFields?[0].text, itemName != "" else { return }
            ItemController.sharedInstance.create(itemName: itemName)
        }
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as?
            ItemTableViewCell else {return UITableViewCell()}

        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.updateViews(item: item)
        cell.delegate =  self as? ItemTableViewCellDelegate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ItemController.sharedInstance.delete(item: item)
        }    
    }
} // Class end

// MARK: - NSFetchedResultsControllerDelegate
extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
            
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath
                else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath
                else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("NSFetchedResultsChangeType has new unhandled cases")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
} // Extension end
