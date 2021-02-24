//
//  SessionListViewController.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/23/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit
#if os(tvOS)
import tvOSShared
#else
import shared
#endif

class SessionListViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Outlets
    
    // MARK: - Class Variables
    private var allSessions: [SessionOverviewItem] = []
    private var filteredSessions: [SessionOverviewItem] = []
    
    var filterString = "" {
        didSet {
            // Return if the filter string hasn't changed.
            guard filterString != oldValue else { return }

            // Apply the filter or show all items if the filter string is empty.
            if filterString.isEmpty {
                filteredSessions = allSessions
            }
            else {
                filteredSessions = allSessions.filter { $0.name.localizedStandardContains(filterString) }
            }
            
            // Reload the collection view to reflect the changes.
            tableView?.reloadData()
        }
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignageSDK.shared.loadSessionOverviews { [weak self] (sessionOverItems: [SessionOverviewItem]) in
            guard let weakSelf = self else { return }
            weakSelf.allSessions = sessionOverItems
            weakSelf.filteredSessions = weakSelf.allSessions
            weakSelf.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SessionListCell = tableView.dequeueReusableCell(withIdentifier: "SessionListCell", for: indexPath) as! SessionListCell
        cell.configure(for: filteredSessions[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manager = DisplayManager(session: filteredSessions[indexPath.row])
        manager.displayFirstScreen(from: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
    }

}


class SessionListCell: UITableViewCell {
    
    func configure(for session: SessionOverviewItem?) {
        textLabel?.text = session?.name
        if let session = session {
            detailTextLabel?.text = Platform().formatSessionTime(startTime: session.startTime, endTime: session.endTime)
        } else {
            detailTextLabel?.text = nil
        }
        
    }
    
}
