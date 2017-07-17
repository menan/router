//
//  MasterViewController.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-15.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import SWXMLHash
import GoogleMobileAds
import Foundation


class MasterViewController: UITableViewController, UISearchBarDelegate, GADBannerViewDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    var route = 199
    
    var bannerView: GADBannerView!
    
    var routes: [XMLIndexer]?
    var filtered: [XMLIndexer]?
    var searchActive = false
    
    let service = Service.shared
    let utilities = Utilities.shared


    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadRoutes()
        
        
        if let value = ProcessInfo.processInfo.environment["showAds"], let showAds = Bool(value), showAds {
            bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
            self.view.addSubview(bannerView)
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.delegate = self
        }

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
                controller.routeId = self.route
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
        
        guard let stops = self.getStops(), stops.count >= indexPath.row  else { return [] }
        
        let object = stops[indexPath.row]
        
        guard let tag = object.attr("tag"), let tagInt = Int(tag) else { return [] }
        
        let isFav = utilities.isFavorite(tag: tagInt, ofKind: .stop)
        
        
        var title = "Mark as Favorite"
        var backgroundColor = UIColor.blue
        
        if isFav {
            title = "Remove Favorite"
            backgroundColor = UIColor.gray
        }
        
        let action1 = UITableViewRowAction(style: .default, title: title, handler: {
            (action, indexPath) in
            if isFav {
                self.utilities.removeFromFavorites(tag: tagInt, ofKind: .stop)
            }
            else{
                self.utilities.markAsFavorite(tag: tagInt, ofKind: .stop)
            }
            self.tableView.setEditing(false, animated: true)
        })
        action1.backgroundColor = backgroundColor
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
    
    
    // MARK: - Google Ad Events
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }

}

