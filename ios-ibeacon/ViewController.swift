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
    
    var group_name = String()
    var json_link = String()
    
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
        
        let url = "http://beacons.philipjburke.com:5000/get_agenda"
        var urlWithParams = url
        
        for beacon in beacons {
            
            let uuid = beacon.proximityUUID
            let major = beacon.major
            let minor = beacon.minor
            let canvas_id = "self"
            
            urlWithParams = url + "?uuid=\(uuid)&canvas_id=\(canvas_id)&major=\(major)&minor=\(minor)"
            
            let urlRequest = URL(string: urlWithParams)
            
            URLSession.shared.dataTask(with:urlRequest!) { (data, response, err) in
                if err != nil {
                    print(err)
                } else {
                    do {
                        let parsedJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        
                        self.group_name = parsedJSON["group_name"] as! String
                        self.json_link = parsedJSON["url"] as! String
                        
                    } catch let err as NSError {
                        print(err)
                    }
                }
                
                }.resume()
        }
        
        createLabel(labelText: String(self.group_name))
        createButton()
    }
    
    func createLabel(labelText: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = labelText
        self.view.addSubview(label)
    }
    
    func createButton () {
        let button = UIButton();
        button.setTitle("Download Notes", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        button.center = CGPoint(x: 160, y: 350)
        button.addTarget(self, action: #selector((ViewController).buttonPressed), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func buttonPressed(sender: UIButton!) {
        if URL(string: json_link) != nil {
            UIApplication.shared.openURL(URL(string: json_link)!)
        }
    }
    
}

