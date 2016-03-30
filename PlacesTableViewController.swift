//
//  PlacesTableViewController.swift
//  ToDo
//
//  Created by Andrew Burns on 12/28/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit
import CoreData

class PlacesTableViewController: UITableViewController {
    var places = [[Place]]()
    
    
    @IBAction func refresh(sender: AnyObject) {
      refresh()
    }
    
    func refresh() {
        places.removeAll()
        getPlaces()
        self.tableView.reloadData()
        self.refreshControl!.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            let place = places[indexPath.section][indexPath.row]
            context.deleteObject(place as NSManagedObject)
            do {
                try context.save()
            } catch {}
            refresh()
        }
    }
//    func deleteAllData(entity: String)
//    {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: entity)
//        fetchRequest.returnsObjectsAsFaults = false
//        
//        do
//        {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            for managedObject in results
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                managedContext.deleteObject(managedObjectData)
//            }
//        } catch let error as NSError {
//            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
//        }
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView!.hidden = true
        tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.separatorColor = UIColor(netHex: 0x344038)
        getPlaces()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func getPlaces() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()

        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Place", inManagedObjectContext: managedObjectContext)

        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for res in result {
                places.append([res as! Place])
            }
            
        } catch {
            let fetchError = error as NSError
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
        return places.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places[section].count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("place", forIndexPath: indexPath) as! PlaceTableViewCell
        cell.place = places[indexPath.section][indexPath.row]
        // Configure the cell...
        if indexPath.section % 2 == 0 {
            cell.backgroundColor = UIColor(netHex: 0xFFFFFF)
        } else {
            cell.backgroundColor = UIColor(netHex: 0xDCDCDC)
        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Place" {
            if let mvc = segue.destinationViewController as? MapViewController {
                if let placeCell = sender as? PlaceTableViewCell {
                    mvc.place = placeCell.place
                }
            }
        } else if segue.identifier == "New Place" {
            if let _ = segue.destinationViewController as? MapViewController {
            }
        }
    }


}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
