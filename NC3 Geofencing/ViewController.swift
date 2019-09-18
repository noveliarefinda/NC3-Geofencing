//
//  ViewController.swift
//  NC3 Geofencing
//
//  Created by Novelia Refinda on 18/09/19.
//  Copyright © 2019 Novelia Refinda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications
import LocalAuthentication


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate

{
    
    @IBOutlet weak var peta: MKMapView!
    
    //STEP 1
    //bikin objek untuk location manager
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var keterangan: UILabel!
    
    let pesan_masuk_wilayah = "Welcome! Don't forget to clock in!"
    let pesan_keluar_wilayah = "See you tommorow!"
    
    
    //FACE ID STEP 1
    var context = LAContext()
    
    /// The current authentication state.
    var state = AuthenticationState.loggedout
    
    
    
    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        
        
            //STEP 2
           //AGAR AKURASI YANG LEBIH TEPAT
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
            //STEP 3
            //cara munculin lokasi user di mapkit
        
            peta.showsUserLocation = true
        
            //STEP 4
            //UPDATE LOCATION
            locationManager.startUpdatingLocation()
        
            //STEP 6
            //untuk zoom in di peta
        
            centerViewUser()
        
        //STEP7 krena uda tambah delegate diatas
        
        self.locationManager.delegate = self
        
        //STEP10 panggil peta krena uda ditambah
        
        self.peta.delegate = self
        
        //STEP 1 NOTIF
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in }
        
        
        //FACE ID STEP 3
       
        // The biometryType, which affects this app's UI when state changes, is only meaningful
        //  after running canEvaluatePolicy. But make sure not to run this test from inside a
        //  policy evaluation callback (for example, don't put next line in the state's didSet
        //  method, which is triggered as a result of the state change made in the callback),
        //  because that might result in deadlock.
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        //Part 7
        // Set the initial app state. This impacts the initial state of the UI as well.~
        state = .loggedout
        
        faceidTriggered()
        //FACE ID STEP 6
        
        
    }
    
    //STEP 5
    // untuk tengahin lokasi user di CL, ANGKA LEBIH KECIL LEBIH ZOOM IN
    
    func centerViewUser()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000); peta.setRegion(region, animated: true)
        }
    }
    
    //STEP6 SET UP GEOFENCING
    
    func setUpGeofencing()
    {
        //radius 100 itu sampe the breeze dan unilever
        
        let geofencingCenter = CLLocationCoordinate2DMake(-6.3023, 106.6522)
        
        //untuk bikin batasan
        
        let geofencingRegion = CLCircularRegion(center: geofencingCenter, radius: 50, identifier: "Current Location")
        
        geofencingRegion.notifyOnExit = true
        geofencingRegion.notifyOnEntry = true
        self.locationManager.startMonitoring(for: geofencingRegion)
        
        //buat koordinat di peta
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let mapRegion = MKCoordinateRegion(center: geofencingCenter, span: span)
        self.peta.setRegion(mapRegion, animated: true)
        
        //buat batesan lingkaran di peta
        
        let regionCircle = MKCircle(center: geofencingCenter, radius: 50)
        self.peta.addOverlay(regionCircle)
        self.peta.showsUserLocation = true;
        
    }
    
    //STEP 7
    //kasi tau uda mulai nyari - start monitoring
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print ("Start Monitoring Region: \(region.identifier)")
        keterangan.text = "Monitoring Region"
    }
    
    //STEP 8
    //detect masuk atau keluar dari buletan
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(pesan_masuk_wilayah)
        keterangan.text = pesan_masuk_wilayah
        
        
        //STEP NOTIF 3 - bikin munculin notif pas masuk
        self.createLocalNotification(message: pesan_masuk_wilayah, identifier: pesan_masuk_wilayah)
        
        //STEP NOTIF 5
        self.timeNotification(message: "It's been 1 hour since you arrived, have you clock in?", identifier: "Sudah 1 Jam")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(pesan_keluar_wilayah)
        keterangan.text = pesan_keluar_wilayah
        
          //STEP NOTIF 4 - bikin munculin notif pas keluar
        self.createLocalNotification(message: pesan_keluar_wilayah, identifier: pesan_keluar_wilayah)
    }
 
    //STEP 9
    //UNTUK PILIHAN AUTHORIZATION ATAU DIGANTI STATUS AUTHORIZATIONNYA. CUMA GEOFENCING HARUS SELALU ALWAYS
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.setUpGeofencing()
    }
    
    //STEP 11
    //untuk buletan keliatan di peta
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        overlayRenderer.lineWidth = 4.0
        overlayRenderer.strokeColor = UIColor(red: 7.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1)
        overlayRenderer.fillColor = UIColor(red: 0.0/255.0, green: 203.0/255.0, blue: 208.0/255.0, alpha: 0.7)
        return overlayRenderer
        
    }
    
    //STEP 2 NOTIF
    
    func createLocalNotification(message: String, identifier: String)
    {
        //create a local notification
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = UNNotificationSound.default
        
        //deliver di notif
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: nil)
        
        //schedule the notif
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in}
    }
    
    //STEP 4 NOTIF
    //bikin fungsi time notif
    
    func timeNotification(message: String, identifier: String)
    {
        //create a local notification
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = UNNotificationSound.default
        
        //STEP NOTIF 5
        //tambah reminder sejam setelah masuk
        let timeInSeconds: TimeInterval = 5
        
        //the actual trigger object
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds, repeats: false)
        
        //notification request object
        let request = UNNotificationRequest(identifier: identifier, content: content , trigger: trigger)
        
        //schedule the notif
        let centerTime = UNUserNotificationCenter.current()
        centerTime.add(request) { (error) in}
    }
    
    
    //FACE ID STEP 5
    func faceidTriggered()
    {
        //Part 1
        if state == .loggedin
        {
            // Log out immediately.
            state = .loggedout
            
            //Part 13
        }
        else
        {
            // Get a fresh context for each login. If you use the same context on multiple attempts
            //  (by commenting out the next line), then a previously successful authentication
            //  causes the next policy evaluation to succeed without testing biometry again.
            //  That's usually not what you want.
            context = LAContext()
            context.localizedCancelTitle = "Enter Username/Password"
            
            //Part 9
            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
            {
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    
                    //Part 2
                    if success
                    {
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }
                        //Part 14
                    }
                    else
                    {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        // Fall back to a asking for username and password.
                        // ...
                    }}
                //Part 10
            }
            else
            {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                // Fall back to a asking for username and password.
                // ...
            }
        }
    }
}

//STEP 2 FACE ID
/// The available states of being logged in or not.
enum AuthenticationState
{
    case loggedin, loggedout
}
