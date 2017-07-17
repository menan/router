//
//  Service.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class Service {
    
    static let shared = Service()
    
    let debug = false
    
    var agency = "ttc"
    
    
    //MARK: Route API Calls
    
    func loadRouteDetails(route routeId: Int, completion: @escaping (_ result: [XMLIndexer],_ title: String?) -> Void){
        
        let request = Alamofire.request("\(Constants.domain)/service/publicXMLFeed?command=routeConfig&a=\(agency)&r=\(routeId)")
            .response { response in
                
                if let data = response.data {
                    let xml = SWXMLHash.parse(data)
                    let stops = xml["body"]["route"]["stop"].all
                    let title = xml["body"]["route"].element?.attribute(by: "title")?.text
                    completion(stops, title)
                }
                
        }
        if debug {
            debugPrint(request)
        }
    }
    
    
    func loadRoutes(agency agencyId: String, completion: @escaping (_ result: [XMLIndexer]) -> Void){
        
        let request = Alamofire.request("\(Constants.domain)/service/publicXMLFeed?command=routeList&a=\(agencyId)")
            .response { response in
                
                if let data = response.data {
                    let xml = SWXMLHash.parse(data)
                    completion(xml["body"]["route"].all)
                }
                
        }
        if debug {
            debugPrint(request)
        }
    }
    
    
    
    func loadPredictions(route routeId: Int, stop stopId: Int, completion: @escaping (_ result: [XMLIndexer],_ title: String?) -> Void){
        
        let request = Alamofire.request("\(Constants.domain)/service/publicXMLFeed?command=predictions&a=\(agency)&r=\(routeId)&s=\(stopId)")
            .response { response in
                
                if let data = response.data {
                    let xml = SWXMLHash.parse(data)
                    let predictions = xml["body"]["predictions"]["direction"].children
                    let title = xml["body"]["predictions"]["direction"].element?.attribute(by: "title")?.text
                    completion(predictions, title)
                }
                
        }
        if debug {
            debugPrint(request)
        }
    }
}
