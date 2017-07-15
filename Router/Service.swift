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
    
    func loadRouteDetails(route routeId: Int, completion: @escaping (_ result: XMLIndexer) -> Void, failed: @escaping (_ error: XMLIndexer) -> Void){
        
        let request = Alamofire.request("\(Constants.domain)/service/publicXMLFeed?command=routeConfig&a=\(agency)&r=\(routeId)")
            .response { response in
                
                if let data = response.data {
                    let xml = SWXMLHash.parse(data)
                    completion(xml)
                }
                
        }
        if debug {
            debugPrint(request)
        }
    }
    
    
    func loadRoutes(agency agencyId: String, completion: @escaping (_ result: XMLIndexer) -> Void, failed: @escaping (_ error: XMLIndexer) -> Void){
        
        let request = Alamofire.request("\(Constants.domain)/service/publicXMLFeed?command=routeList&a=\(agencyId)")
            .response { response in
                
                if let data = response.data {
                    let xml = SWXMLHash.parse(data)
                    completion(xml)
                }
                
        }
        if debug {
            debugPrint(request)
        }
    }
}
