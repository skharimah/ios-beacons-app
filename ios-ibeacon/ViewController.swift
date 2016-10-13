//
//  ViewController.swift
//  ios-ibeacon
//
//  Created by Sarah Kharimah on 10/12/16.
//  Copyright © 2016 Sarah Kharimah. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "F3F73797-8720-45A1-9C6A-B105E24D1484")! as UUID, major: 1000, minor: 1012, identifier: "ios_app_aruba")
    let colors = [
        54482: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        31351: UIColor(red: 255/255, green: 100/255, blue: 220/255, alpha: 1),
        27327: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
        for beacon in beacons {
            if(beacon.rssi >= -30) {
                self.view.backgroundColor = self.colors[54482]
            } else if (beacon.rssi >= -50 ) {
                self.view.backgroundColor = self.colors[31351]
            } else {
                self.view.backgroundColor = self.colors[27327]
            }
        }
    }


}

