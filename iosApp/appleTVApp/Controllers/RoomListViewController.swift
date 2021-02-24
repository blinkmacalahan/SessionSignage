//
//  RoomListViewController.swift
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

class RoomListViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Outlets
    
    // MARK: - Class Variables
    private var allRooms: [String] = []
    private var filteredRooms: [String] = []
    
    var filterString = "" {
        didSet {
            // Return if the filter string hasn't changed.
            guard filterString != oldValue else { return }

            // Apply the filter or show all items if the filter string is empty.
            if filterString.isEmpty {
                filteredRooms = allRooms
            } else {
                filteredRooms = allRooms.filter { $0.localizedStandardContains(filterString) }
            }
            
            // Reload the collection view to reflect the changes.
            tableView?.reloadData()
        }
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignageSDK.shared.loadRooms { [weak self] (rooms: [String]) in
            guard let weakSelf = self else { return }
            weakSelf.allRooms = rooms
            weakSelf.filteredRooms = weakSelf.allRooms
            weakSelf.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoomListCell = tableView.dequeueReusableCell(withIdentifier: "RoomListCell", for: indexPath) as! RoomListCell
        cell.configure(for: filteredRooms[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manager = DisplayManager(room: filteredRooms[indexPath.row])
        manager.displayFirstScreen(from: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
    }

}


class RoomListCell: UITableViewCell {
    
    func configure(for room: String?) {
        textLabel?.text = room
        detailTextLabel?.text = nil
    }
    
}
