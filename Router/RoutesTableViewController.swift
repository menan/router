//
//  RoutesTableViewController.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import SWXMLHash

class RoutesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var routes: [XMLIndexer]?
    var filtered: [XMLIndexer]?
    var searchActive = false
    
    var loading = true
    
    let utilities = Utilities.shared
    
    var masterViewCtrl: MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.shared.loadRoutes(agency: Config.agency, completion: { (r) in
            self.loading = false
            self.routes = r
            self.tableView.reloadData()
        })
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
        if loading {
            searchActive = false
            return
        }
        filtered = routes?.filter(byTitle: searchText)
        
        if searchText == "" {
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 1
        }
        guard let routes = self.getStops() else { return 0 }
        return routes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath)
        if loading {
            cell.textLabel?.text = "Loading..."
            return cell
        }
        
        guard let stops = self.getStops() else { return cell }
        
        let object = stops[indexPath.row]
        let title = object.attr("title")
        if let tag = object.attr("tag"), let tagInt = Int(tag), tagInt == masterViewCtrl?.route{
            cell.textLabel?.textColor = UIColor.blue
        }
        else{
            cell.textLabel?.textColor = UIColor.black
        }
        
        cell.textLabel?.text = title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if loading {
            return
        }
        
        guard let stops = self.getStops() else { return }
        
        let object = stops[indexPath.row]
        
        guard let tag = object.attr("tag"),
            let tagInt = Int(tag),
            let masterViewCtrl = masterViewCtrl else { return }
        
        
        masterViewCtrl.route = tagInt
        masterViewCtrl.reloadRoutes()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if loading {
            return []
        }
        
        guard let stops = self.getStops(), stops.count >= indexPath.row  else { return [] }
        
        let object = stops[indexPath.row]
        
        guard let tag = object.attr("tag"), let tagInt = Int(tag) else { return [] }
        
        let isFav = utilities.isFavorite(tag: tagInt, ofKind: .route)
        
        
        var title = "Mark as Favorite"
        var backgroundColor = UIColor.blue
        
        if isFav {
            title = "Remove Favorite"
            backgroundColor = UIColor.gray
        }
        
        let action1 = UITableViewRowAction(style: .default, title: title, handler: {
            (action, indexPath) in
            if isFav {
                self.utilities.removeFromFavorites(tag: tagInt, ofKind: .route)
            }
            else{
                self.utilities.markAsFavorite(tag: tagInt, ofKind: .route)
            }
            self.tableView.setEditing(false, animated: true)
        })
        action1.backgroundColor = backgroundColor
        return [action1]
    }
    
    
    // MARK: - Helper Functions
    
    func getStops() -> [XMLIndexer]?{
        var localRoutes = routes
        if searchActive { localRoutes = filtered }
        return localRoutes
    }
    
    
    
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
