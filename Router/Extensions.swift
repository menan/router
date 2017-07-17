//
//  Extensions.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import Foundation
import SWXMLHash

extension Array where Iterator.Element == XMLIndexer {
    
    func filter(byTitle title: String) -> [XMLIndexer]{
        var results = [XMLIndexer]()
        
        for route in self {
            guard let thisTitle = route.element?.attribute(by: "title")?.text.lowercased() else { continue }
            if  thisTitle.range(of:title.lowercased()) != nil{
                results.append(route)
            }
        }
        return results
    }
    
}


extension XMLIndexer {
    func attr(_ key: String) -> String? {
        guard let element = self.element, let value = element.attribute(by: key) else { return "" }
        return value.text
    }
    
    
}
