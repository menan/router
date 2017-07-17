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
    
    var loading = true
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            
            
            guard let stopIdStr = detail.attr("tag") else { return }
            
            self.title = "Stop \(stopIdStr)"
            
            Service.shared.loadPredictions(route: routeId, stop: stopIdStr, completion: { (xml, title) in
                self.loading = false
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
        if self.loading{
            return 1
        }
        guard let p = self.predictions, p.count > 0 else { return 1 }
        return p.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.loading{
            return nil
        }
        
        guard let predictions = self.predictions, predictions.count > 0 else {
           return nil
        }
        
        return "Expected in"
        
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if self.loading{
            return nil
        }
        return self.directionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath)
        
        if self.loading{
            cell.textLabel?.text = "Loading..."
            cell.detailTextLabel?.text = ""
            
            return cell
        }
        
        guard let p = self.predictions, p.count > 0 else {
            
            cell.textLabel?.text = "No Data"
            cell.detailTextLabel?.text = "No prediction entries found."
            
            return cell
        }
        
        let object = p[indexPath.row]
        
        let minutes = object.attr("minutes")
        let seconds = object.attr("seconds")
        let vehicleId = object.attr("vehicle")
        if let depature = object.attr("isDeparture") {
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

