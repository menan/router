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
    
    var masterViewCtrl: MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.shared.loadRoutes(agency: "ttc", completion: { (r) in
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
        guard let routes = self.getStops() else { return 0 }
        return routes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath)

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
        
        
        guard let stops = self.getStops() else { return }
        
        let object = stops[indexPath.row]
        
        guard let tag = object.attr("tag"),
            let tagInt = Int(tag),
            let masterViewCtrl = masterViewCtrl else { return }
        
        
        masterViewCtrl.route = tagInt
        masterViewCtrl.reloadRoutes()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
