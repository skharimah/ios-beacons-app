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
    
    let restApiManager = RestApiManager()
    
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
        
        for beacon in beacons {
            
            let uuid = String(describing: beacon.proximityUUID)
            let major = beacon.major
            let minor = beacon.minor
            let canvasId = "self"
            
            let urlWithParams = restApiManager.getUrlWithParams(baseUrl: url, uuid: uuid, canvasId: canvasId, major: (Int)(major), minor: (Int)(minor))
            restApiManager.sendHttpRequest(urlWithParams: urlWithParams)
        }
        
        createGroupLabel(labelText: String(restApiManager.getGroupName()))
        createDownloadButton()
    }
    
    func createGroupLabel(labelText: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = labelText
        self.view.addSubview(label)
    }
    
    func createDownloadButton () {
        let button = UIButton();
        button.setTitle("Download Notes", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        button.center = CGPoint(x: 160, y: 350)
        button.addTarget(self, action: #selector((ViewController).buttonPressed), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func buttonPressed(sender: UIButton!) {
        if URL(string: restApiManager.getCanvasUrl()) != nil {
            UIApplication.shared.openURL(URL(string: restApiManager.getCanvasUrl())!)
        }
    }
    
}

