//
//  NewToDoViewController.swift
//  ToDo
//
//  Created by Andrew Burns on 12/29/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit
import CoreData


class NewToDoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var placeData = [Place]()

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var placePicker: UIPickerView! {
        didSet {
            placePicker.delegate = self
            placePicker.dataSource = self
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        print("HI")
        if titleTextField.text != "" && infoTextField.text != "" {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContext
            let newitem = NSEntityDescription.insertNewObjectForEntityForName("ToDoItem", inManagedObjectContext: managedObjectContext) as! ToDoItem
            newitem.title = titleTextField.text
            newitem.info = infoTextField.text
            //        let date = NSDate()
            //        let formatter = NSDateFormatter()
            //        formatter.timeStyle = .ShortStyle
            newitem.date = datePicker.date
            let selectedValue = placeData[placePicker.selectedRowInComponent(0)]
            newitem.place = selectedValue
            
            
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            performSegueWithIdentifier("unwind back to ToDo Table", sender: self)
        } else {
            let alert = UIAlertController(
                title: "Did not save",
                message: "Enter all fields" ,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alert.addAction(UIAlertAction(
                title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: nil
                ))
            presentViewController(alert, animated: true, completion: nil)
        }

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        getPlaceData()
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func getPlaceData() {
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
                placeData.append(res as! Place)
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
    

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placeData[row].title!
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeData.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
