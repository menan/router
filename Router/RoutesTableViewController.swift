//
//  RoutesTableViewController.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import SWXMLHash

class RoutesTableViewController: UITableViewController {
    
    var routes: XMLIndexer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.shared.loadRoutes(agency: "ttc", completion: { (r) in
            self.routes = r
            self.tableView.reloadData()
        }) { (error) in
            print("Error \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let routes = self.getStops() else {
            return 0
        }
        
        return routes.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath)

        
        guard let stops = self.getStops() else {
            return cell
        }
        
        let object = stops[indexPath.row]
        let title = object.element?.attribute(by: "title")
        cell.textLabel?.text = title?.text

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    func getStops() -> XMLIndexer?{
        
        guard let r = routes else {
            return nil
        }
        
        return r["body"]["route"]
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
