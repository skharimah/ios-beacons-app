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
    
    func getUrlWithParams(baseUrl: String, uuid: String, canvasId: String, major: (Int), minor: (Int)) -> String {
        let urlWithParams = baseUrl + "?uuid=\(uuid)&canvas_id=\(canvasId)&major=\(major)&minor=\(minor)"
        return urlWithParams
    }
    
    func getGroupName() -> String {
        return self.groupName
    }
    
    func getCanvasUrl() -> String {
        return self.canvasUrl
    }
    
    func setGroupName(newGroupName: String) {
        self.groupName = newGroupName
    }
    
    func setCanvasUrl(newCanvasUrl: String) {
        self.canvasUrl = newCanvasUrl
    }
    
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


