//
//  SearchTableViewController.swift
//  switchPriceKana
//
//  Created by Woohyun Kim on 2020/09/29.
//  Copyright © 2020 Woohyun Kim. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var filteredData: [String] = []
    var resultSearchController: UISearchController!
    var selectedGame: String = ""
    var selectedIndex: Int = 0
    let lowercasedTitles = switchTitles.map { $0.lowercased() }
    let SC = UISearchController.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = resultSearchController.searchBar
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        resultSearchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if resultSearchController.isActive{
            return filteredData.count
        }else{
            return switchTitles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        if resultSearchController.isActive{
            cell.textLabel?.text = filteredData[indexPath.row]
        }else{
            cell.textLabel?.text = switchTitles[indexPath.row]
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let lowercasedSearch = searchController.searchBar.text?.lowercased()
        if (searchController.searchBar.text?.count)! > 0{
            filteredData.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", lowercasedSearch!)
            let array = (lowercasedTitles as NSArray).filtered(using: searchPredicate)
            filteredData = array as! [String]
            tableView.reloadData()
        }else{
            filteredData.removeAll(keepingCapacity: false)
            filteredData = switchTitles
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if filteredData.count > 0 {
            selectedGame = filteredData[indexPath.row]
            resultSearchController.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "unwindSegue", sender: self)
            })
        }else{
            selectedGame = switchTitles[indexPath.row]
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        }
            resultSearchController.searchBar.text = selectedGame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegue"{
            if let svc = segue.destination as? SwitchViewController {
                svc.searchBar.text = selectedGame.replacingOccurrences(of: " ", with: "+").lowercased()
                svc.searchBarSearchButtonClicked(svc.searchBar)
            }
        }
    }
}
