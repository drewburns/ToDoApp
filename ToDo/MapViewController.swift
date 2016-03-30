//
//  MapViewController.swift
//  ToDo
//
//  Created by Andrew Burns on 12/27/15.
//  Copyright © 2015 Andrew Burns. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    var place: Place!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet{
            mapView.delegate = self
        }
    }
    
    
    
//    MARK: - Searching
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "place")
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContext
            self.place = NSEntityDescription.insertNewObjectForEntityForName("Place", inManagedObjectContext: managedObjectContext) as! Place
            self.place.title = self.pointAnnotation.title
            self.place.subtitle = self.pointAnnotation.subtitle
            self.place.latitude = self.pointAnnotation.coordinate.latitude
            self.place.longitude = self.pointAnnotation.coordinate.longitude
            

        }
    }
    
//    MARK: - Annotations
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("waypoint")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier:"waypoint")
            view!.canShowCallout = true
        } else {
            view!.annotation = annotation
        }
        
        view!.leftCalloutAccessoryView = nil
        view!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        
        return view
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .OverFullScreen
    }
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navcon = UINavigationController(rootViewController: controller.presentedViewController)
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        visualEffectView.frame = navcon.view.bounds
        navcon.view.insertSubview(visualEffectView, atIndex: 0) // "back-most" subview
        return navcon
    }

// MARK: - Loads
    override func viewDidLoad() {
        if place != nil {
            var array = Array<Place>()
            array.insert(place, atIndex: 0)
            
            mapView.addAnnotation(array.first as! MKAnnotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
        if mapView.annotations.count > 0 {
            searchButton.title = ""
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegueWithIdentifier("Edit Place", sender: view)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit Place" {
//            if let place = (sender as? MKAnnotationView)?.annotation as? Place {
                if let epvc = segue.destinationViewController as? EditPlaceViewController {
                    if let ppc = epvc.popoverPresentationController {
                        ppc.delegate = self
                        let coordinatePoint = mapView.convertCoordinate(place.coordinate, toPointToView: mapView)
                        ppc.sourceRect = (sender as! MKAnnotationView).popoverSourceRectForCoordinatePoint(coordinatePoint)
                        epvc.place = self.place
                        let minimumSize = epvc.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                        epvc.preferredContentSize = CGSize(width: CGFloat(320), height: minimumSize.height)
                    }
                }
//            }
        }
    }
    
    @IBAction func unwindToMapView(segue: UIStoryboardSegue) {
        
    }


}




//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//
//        let managedObjectContext = appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest()
//
//        // Create Entity Description
//        let entityDescription = NSEntityDescription.entityForName("Place", inManagedObjectContext: managedObjectContext)
//
//        // Configure Fetch Request
//        fetchRequest.entity = entityDescription
//
//        do {
//            var result = try managedObjectContext.executeFetchRequest(fetchRequest)
//            result = result as! [Place]
//            print("Searched")
//            print(result.first)
//            print("Loaded")
//            print(place)
//            mapView.addAnnotation(result.first as! MKAnnotation)
//
//
//
//        } catch {
//            let fetchError = error as NSError
//            print(fetchError)
//        }


// Do any additional setup after loading the view.


extension MKAnnotationView {
    func popoverSourceRectForCoordinatePoint(coordinatePoint: CGPoint) -> CGRect {
        var popoverSourceRectCenter = coordinatePoint
        popoverSourceRectCenter.x -= frame.width / 2 - centerOffset.x - calloutOffset.x
        popoverSourceRectCenter.y -= frame.height / 2 - centerOffset.y - calloutOffset.y
        return CGRect(origin: popoverSourceRectCenter, size: frame.size)
    }
}
