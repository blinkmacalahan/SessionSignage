//
//  MainSelectionViewController.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/23/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit

class MainSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Custom Actions
    
    // MARK: - User Actions
    
    @IBAction func individualSessionAction(_ sender: Any) {
        // Load a `SearchResultsViewController` from its storyboard.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchResultsController = storyboard.instantiateViewController(withIdentifier: "SessionListViewController") as? SessionListViewController else {
            fatalError("Unable to instatiate a SessionListViewController from the storyboard.")
        }
        
        /*
         Create a UISearchController, passing the `searchResultsController` to
         use to display search results.
         */
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.placeholder = NSLocalizedString("Search Session Name", comment: "")
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Contain the `UISearchController` in a `UISearchContainerViewController`.
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        
        // Only this controlle is using the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.pushViewController(searchContainer, animated: true)
    }
    
    @IBAction func roomSessionsAction(_ sender: Any) {
        // Load a `SearchResultsViewController` from its storyboard.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchResultsController = storyboard.instantiateViewController(withIdentifier: "RoomListViewController") as? RoomListViewController else {
            fatalError("Unable to instatiate a RoomListViewController from the storyboard.")
        }
        
        /*
         Create a UISearchController, passing the `searchResultsController` to
         use to display search results.
         */
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.placeholder = NSLocalizedString("Search Room Name", comment: "")
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Contain the `UISearchController` in a `UISearchContainerViewController`.
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        
        // Only this controlle is using the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.pushViewController(searchContainer, animated: true)
    }
    
    @IBAction func overallStatsAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let statsController = storyboard.instantiateViewController(withIdentifier: "OverallStatsViewController") as? OverallStatsViewController else {
            fatalError("Unable to instatiate a OverallStatsViewController from the storyboard.")
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.pushViewController(statsController, animated: true)
    }

}
