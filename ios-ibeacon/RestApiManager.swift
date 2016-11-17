//
//  RestApiManager.swift
//  ios-ibeacon
//
//  Created by Sarah Kharimah on 11/16/16.
//  Copyright © 2016 Sarah Kharimah. All rights reserved.
//

import Foundation

class RestApiManager {
    
    private var groupName = String()
    private var canvasUrl = String()
    
    /// Generate a url with the required parameters.
    ///
    /// - parameter baseUrl:  Endpoint url for the HTTP request
    /// - parameter uuid:     iBeacon ProximityUUID
    /// - parameter canvasId: Canvas ID associated to user
    /// - parameter major:    iBeacon major number
    /// - parameter minor:    iBeacon minor number
    ///
    /// - returns: base url with specified parameters to be used for HTTP request
    func getUrlWithParams(baseUrl: String, uuid: String, canvasId: String, major: (Int), minor: (Int)) -> String {
        let urlWithParams = baseUrl + "?uuid=\(uuid)&canvas_id=\(canvasId)&major=\(major)&minor=\(minor)"
        return urlWithParams
    }
    
    /// Return "group_name" field value from JSON response.
    ///
    /// - returns: "group_name" field value
    func getGroupName() -> String {
        return self.groupName
    }
    
    /// Return "url" field value from JSON response.
    ///
    /// - returns: "url" field value
    func getCanvasUrl() -> String {
        return self.canvasUrl
    }
    
    /// Store the "group_name" field value from JSON response into the class' private variable.
    ///
    /// - parameter newGroupName: "group_name" field value to update the class' variable
    private func setGroupName(newGroupName: String) {
        self.groupName = newGroupName
    }
    
    /// Store the "canvas_url" field value from JSON response into the class' private variable.
    ///
    /// - parameter newCanvasUrl: "canvas_url" field value to update the class' variable
    private func setCanvasUrl(newCanvasUrl: String) {
        self.canvasUrl = newCanvasUrl
    }
    
    /// Send GET HTTP request to the provided url server.
    ///
    /// - parameter urlWithParams: base url with specified parameters to be used for HTTP request
    func sendHttpRequest(urlWithParams: String) {
        
        let urlRequest = URL(string: urlWithParams)
        
        URLSession.shared.dataTask(with:urlRequest!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    let parsedJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                    self.setGroupName(newGroupName: parsedJSON["group_name"] as! String)
                    self.setCanvasUrl(newCanvasUrl: parsedJSON["url"] as! String)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }

}


