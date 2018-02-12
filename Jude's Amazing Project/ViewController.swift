//
//  ViewController.swift
//  Jude's Amazing Project
//
//  Created by Fernando on 2/9/18.
//  Copyright © 2018 Fernando. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController,UNUserNotificationCenterDelegate,CLLocationManagerDelegate  {
    var isGrantedAccess = false
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Persmission
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //Update Location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        //Create Local Notification
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound])
        {(granted, error) in
            self.isGrantedAccess = granted
        }
        
        //Local Notification has a stop Button
        let stopAction = UNNotificationAction(identifier: "stop.action", title: "Stop", options: [])
        let timerCategory = UNNotificationCategory(identifier: "timer.category", actions: [stopAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Youpressedme(_ sender: UIButton) {
        print("You pressed me")
        
        // Location Stuff
        
        self.locationManager.startUpdatingLocation()
        // Create the alert controller
        
        
        //Local Okay or Close alerts
        
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        //self.present(alertController, animated: true, completion: nil)
        
        
        //Add local notification
        if isGrantedAccess{
            
            let content = UNMutableNotificationContent()
            content.title = "HIIT Timer"
            content.body = "30 Seconds Elapsed"
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "timer.category"
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 0.001, repeats: false)
            
            let request = UNNotificationRequest(identifier: "timer.request", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                    print("Error posting notification:\(error.localizedDescription)")
                }
            }
            print("done")
        }
    }
    
    
    // Delegates for Local Notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
}


