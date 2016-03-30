//
//  EditPlaceViewController.swift
//  ToDo
//
//  Created by Andrew Burns on 12/28/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class EditPlaceViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    var place: Place!
    
    
    
    @IBAction func saveForm(sender: AnyObject) {
        save(place.coordinate, title: titleTextField.text!, subtitle: subtitleTextField.text)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = place.title
        subtitleTextField.text = place.subtitle
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func save(coordinate: CLLocationCoordinate2D, title: String, subtitle: String?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
//        let place = NSEntityDescription.insertNewObjectForEntityForName("Place", inManagedObjectContext: managedObjectContext) as! Place
        place.title = title
        place.subtitle = subtitle
        place.latitude = coordinate.latitude as Double
        place.longitude = coordinate.longitude as Double
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

}
