//
//  GroceryListTableViewController.swift
//  ShoppingList
//
//  Created by Tyler on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit
import CoreData

class GroceryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GroceryController.sharedController.fetchedResultsController.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: - Action Button

    @IBAction func addButtonTapped(sender: AnyObject) {
        showAlertController()
    }

    
    // MARK: - Alert Controller
    func showAlertController() {
       
        var itemLabel: UITextField?
        
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = ""
            itemLabel = textField
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let addButton = UIAlertAction(title: "Add", style: .Default) { (_) in
            guard let item = itemLabel?.text where item.characters.count > 0 else { return }
            GroceryController.sharedController.addItem(item)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(addButton)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = GroceryController.sharedController.fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = GroceryController.sharedController.fetchedResultsController.sections else { return 0 }
        return rows[section].numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCellWithIdentifier("groceryItem", forIndexPath: indexPath) as? GroceryTableViewCell,
        item = GroceryController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Groceries else {
            return UITableViewCell()
        }
        
        cell.updateWithGroceryItem(item)
        cell.delegate = self
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = GroceryController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? GroceryTableViewCell
            GroceryController.sharedController.fetchedResultsController.delete(item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GroceryListTableViewController: GroceryTableViewCellDelegate {
    
    func didGetButtonCellTapped(cell: GroceryTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell),
            grocery = GroceryController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Groceries else { return }
            grocery.didGet = !grocery.didGet.boolValue
            cell.groceryItemValueChanged(grocery.didGet.boolValue)
            GroceryController.sharedController.saveToPersistentStorage()
        
        
    }
}

extension GroceryListTableViewController: NSFetchedResultsControllerDelegate {
    
func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case .Update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Move:
            guard let indexPath = indexPath, newIndexPath = newIndexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

}















