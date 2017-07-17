//
//  MasterViewController.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import SWXMLHash

class MasterViewController: UITableViewController, UISearchBarDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    var route = 199
    
    
    var routes: [XMLIndexer]?
    var filtered: [XMLIndexer]?
    var searchActive = false
    
    let service = Service.shared
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadRoutes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = routes?.filter(byTitle: searchText)
        
        if searchText == "" {
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let stops = self.getStops() else { return }
                let stop = stops[indexPath.row]
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = stop
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else {
            if let controller = (segue.destination as! UINavigationController).topViewController as? RoutesTableViewController{
                controller.masterViewCtrl = self
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
        
        return stops.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let stops = self.getStops(), stops.count >= indexPath.row  else { return cell }
        
        let object = stops[indexPath.row]
        
        let title = object.element?.attribute(by: "title")
        let stopId = object.element?.attribute(by: "stopId")
        
        cell.detailTextLabel?.text = title?.text
        cell.textLabel?.text = stopId?.text
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let action1 = UITableViewRowAction(style: .default, title: "Add Favorite", handler: {
            (action, indexPath) in
            print("Action1")
        })
        action1.backgroundColor = UIColor.blue
        return [action1]
    }
    
    // MARK: - Network Calls
    func reloadRoutes() {
        service.loadRouteDetails(route: route, completion: { (r, title) in
            self.routes = r
            self.title = title
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Helper Functions
    func getStops() -> [XMLIndexer]?{
        var localRoutes = routes
        if searchActive { localRoutes = filtered }
        return localRoutes
    }
    
    

}

