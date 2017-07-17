//
//  DetailViewController.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import SWXMLHash

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var predictions: [XMLIndexer]?
    
    var routeId = 199
    
    var directionTitle = ""
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            
            
            guard let stopIdStr = detail.attr("tag"), let stopId = Int(stopIdStr) else { return }
            
            self.title = "Stop \(stopIdStr)"
            
            Service.shared.loadPredictions(route: routeId, stop: stopId, completion: { (xml, title) in
                self.predictions = xml
                if let title = title {
                    self.directionTitle = title
                }
                self.tableView.reloadData()
            })
            
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: XMLIndexer? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    

    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let p = self.predictions else { return 0 }
        return p.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Expected in"
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.directionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath)
        
        guard let p = self.predictions else { return cell }
        
        let object = p[indexPath.row]
        
        let minutes = object.element?.attribute(by: "minutes")?.text
        let seconds = object.element?.attribute(by: "seconds")?.text
        let vehicleId = object.element?.attribute(by: "vehicle")?.text
        if let depature = object.element?.attribute(by: "isDeparture")?.text {
            if let boolDeparture = Bool(depature) {
                var departureString = "Departed"
                if !boolDeparture {
                    departureString = "Not Departed"
                }
                if let vehicleId = vehicleId{
                    cell.detailTextLabel?.text = "Vehicle \(vehicleId)"
                }
            }
            
        }
        
        
        
        cell.textLabel?.text = self.getTime(minutes: minutes, seconds: seconds)
        
        
        return cell
    }
    
    // MARK: - Helper Function
    
    func getTime(minutes: String?, seconds: String?) -> String {
        if minutes == "0"{
            return "\(seconds!) secs"
        }
        return "\(minutes!) mins \(seconds!) secs"
    }

}

