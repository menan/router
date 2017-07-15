//
//  MasterViewController.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import SWXMLHash

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    var routes: XMLIndexer?
    
    let service = Service.shared
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        service.loadRouteDetails(route: 199, completion: { (r) in
            self.routes = r
            self.tableView.reloadData()
            self.title = self.getTitle()
        }) { (error) in
            print("Error \(error)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                guard let stops = self.getStops() else {
                    return
                }
                
                let stop = stops[indexPath.row]
        
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = stop
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let stops = self.getStops() else {
            return 0
        }
        
        return stops.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let stops = self.getStops() else {
            return cell
        }
        
        let object = stops[indexPath.row]
        
        let title = object.element?.attribute(by: "title")
        let stopId = object.element?.attribute(by: "stopId")
        
        cell.detailTextLabel?.text = title?.text
        cell.textLabel?.text = stopId?.text
        
        
        return cell
    }
    
    // MARK: - Helper Functions
    
    func getStops() -> XMLIndexer?{
        
        guard let r = routes else {
            return nil
        }
        
        return r["body"]["route"]["stop"]
        
    }
    
    func getTitle() -> String?{
        
        guard let r = routes else {
            return nil
        }
        
        return r["body"]["route"].element?.attribute(by: "title")?.text
    }


}

