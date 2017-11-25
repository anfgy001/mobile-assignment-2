//
//  MasterViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    let model = SingletonManager.model

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find out what row was selected
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            // Grab the detail view
            let detailView = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            
            // Get the selected cell's text
            let key = model.segueArray[indexPath.row]
            
            // Get the content to display
            let content = model.segueDictionary[key]
            
            // Pass the content to the detail view
            detailView.detailItem = content
            
            // Set up navigation on detail view
            detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            detailView.navigationItem.leftItemsSupplementBackButton = true
        }
        
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.segueArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Get the object to put in the cell
        let text = model.segueArray[indexPath.row]
        
        let dict = model.segueDictionary[text];
        
        cell.imageView!.image = dict;
        
        // Set the text in the cell
        cell.textLabel!.text = text
        
        // Return the cell to be added to the table
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let key = model.segueArray[indexPath.row]
        self.performSegue(withIdentifier: key, sender: self)
    }


    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

