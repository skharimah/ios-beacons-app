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
    var request = URLRequest(url: URL(string: "http://jsonplaceholder.typicode.com/todos/1")!)
    let session = URLSession.shared
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "F3F73797-8720-45A1-9C6A-B105E24D1484")! as UUID, major: 1000, minor: 1012, identifier: "ios_app_aruba")
    
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
        
        request.httpMethod = "GET"
        
        let url = "http://beacons.philipjburke.com:5000/get_agenda"
        var urlWithParams = url
        
        for beacon in beacons {
            
            let uuid = beacon.proximityUUID
            let major = beacon.major
            let minor = beacon.minor
            let canvas_id = "self"
            
            urlWithParams = url + "?uuid=\(uuid)&canvas_id=\(canvas_id)&major=\(major)&minor=\(minor)"
            
            let urlRequest = URL(string: urlWithParams)
            
            print(urlRequest)
            
            URLSession.shared.dataTask(with:urlRequest!) { (data, response, err) in
                if err != nil {
                    print(err)
                } else {
                    do {
                        let parsedJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        print(parsedJSON.description)
                    } catch let err as NSError {
                        print(err)
                    }
                }
                
                }.resume()
        }

    }
    
}

