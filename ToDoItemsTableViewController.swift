//
//  ToDoItemsTableViewController.swift
//  ToDo
//
//  Created by Andrew Burns on 12/28/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit
import CoreData

class ToDoItemsTableViewController: UITableViewController {

    var toDoItems = [[ToDoItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView!.hidden = true
        tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.separatorColor = UIColor(netHex: 0x344038)
        
        getItems()
    }

    @IBAction func refresh(sender: AnyObject) {
        refresh()
    }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    func refresh() {
        toDoItems.removeAll()
        getItems()
        self.tableView.reloadData()
        self.refreshControl!.endRefreshing()
 
    }
    
    func getItems() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("ToDoItem", inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for res in result {
                toDoItems.append([res as! ToDoItem])
            }
        } catch {
            let fetchError = error as! NSError
            print(fetchError)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return toDoItems.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems[section].count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("toDoItem", forIndexPath: indexPath) as! ToDoItemTableViewCell
        cell.toDoItem = toDoItems[indexPath.section][indexPath.row]
        // Configure the cell...
        if indexPath.section % 2 == 0 {
            cell.backgroundColor = UIColor(netHex: 0xFFFFFF)
        } else {
            cell.backgroundColor = UIColor(netHex: 0xDCDCDC)
        }
        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



//
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//
//        }
//    }
//     Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            let item = toDoItems[indexPath.section][indexPath.row]
            context.deleteObject(item as NSManagedObject)
            do {
                try context.save()
            } catch {}
            refresh()
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
    @IBAction func unwindBackToDoTable(segue: UIStoryboardSegue) {
        refresh()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Show ToDo on Map" {
            if let mvc = segue.destinationViewController as? MapViewController {
                if let tvc = sender as? ToDoItemTableViewCell {

                    mvc.place = tvc.toDoItem.place
                }
            }
        }
    }


}
