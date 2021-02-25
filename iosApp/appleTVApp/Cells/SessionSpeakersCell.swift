//
//  SessionSpeakersCell.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/24/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit
#if os(tvOS)
import tvOSShared
#else
import shared
#endif

class SessionSpeakersCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var speakersTable: UITableView!
    
    // MARK: - Variables
    private var currentSpeakers: [Speaker] = []
    
    // MARK: - Configure
    
    func configure(_ speakers: [Speaker]) {
        currentSpeakers = speakers
        speakersTable.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSpeakers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SpeakerCell = tableView.dequeueReusableCell(withIdentifier: "SpeakerCell", for: indexPath) as! SpeakerCell
        cell.configure(currentSpeakers[indexPath.row])
        return cell
    }
    
}
