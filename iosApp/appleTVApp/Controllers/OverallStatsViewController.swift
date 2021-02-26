//
//  OverallStatsViewController.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/26/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit
#if os(tvOS)
import tvOSShared
#else
import shared
#endif

class OverallStatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var sessionsTableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    // MARK: - Variables
    var sessions: [Session]?
    var groups: [String : [Session]] = [:]
    var sortedKeys: [String] = []
    private var animationTimer: Timer?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = nil
        reloadScreen()
    }
    
    // MARK: - UI
    
    func startAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer: Timer) in
            guard let weakSelf = self else { return }
            let currentOffset = weakSelf.sessionsTableView.contentOffset
            if currentOffset.y >= (weakSelf.sessionsTableView.contentSize.height - weakSelf.sessionsTableView.visibleSize.height) {
                weakSelf.animationTimer?.invalidate()
                weakSelf.animationTimer = nil
                Block.performOnMainThreadAfterDelay(5.0) { [weak self] in
                    guard let weakSelf2 = self else { return }
                    weakSelf2.reloadScreen()
                }
                return
            }
            if let firstIndexPath = weakSelf.sessionsTableView.indexPathsForVisibleRows?.first {
                weakSelf.headerLabel.text = weakSelf.sortedKeys[firstIndexPath.section].uppercased()
            }
            weakSelf.sessionsTableView.setContentOffset(CGPoint(x: currentOffset.x, y: currentOffset.y + 50), animated: true)
        })
    }
    
    // MARK: - Reload
    
    func reloadScreen() {
        SignageSDK.shared.loadSessions(reload: true) { [weak self] (loadedSessions: [Session]) in
            var organizedSessions: [String : [Session]] = [:]
            var dates: [Date] = []
            var dateMapping: [Date : String] = [:]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmXXX"
            for nextSession in loadedSessions {
                let dateString = Platform().formatDay(time: nextSession.startTime)
                let timeString = Platform().formatTime(time: nextSession.startTime)
                let sessionDate = "\(dateString), \(timeString)"
                var currentSessions = organizedSessions[sessionDate] ?? []
                currentSessions.append(nextSession)
                organizedSessions[sessionDate] = currentSessions
                
                let date = dateFormatter.date(from: nextSession.startTime) ?? Date()
                if !dates.contains(date) {
                    dates.append(date)
                    dateMapping[date] = sessionDate
                }
            }
            
            var mappedDateKeys: [String] = []
            for nextDate in dates.sorted() {
                if let dateString = dateMapping[nextDate] {
                    mappedDateKeys.append(dateString)
                }
            }
            self?.sortedKeys = mappedDateKeys
            self?.headerLabel.text = self?.sortedKeys.first?.uppercased()
            
            self?.groups = organizedSessions
            self?.sessions = loadedSessions
            self?.sessionsTableView.reloadData()
            self?.sessionsTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 0, height: 0), animated: false)
            Block.performOnMainThreadAfterDelay(5.0) { [weak self] in
                self?.startAnimation()
            }
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedKeys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[sortedKeys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OverallSessionCell = tableView.dequeueReusableCell(withIdentifier: "OverallSessionCell", for: indexPath) as! OverallSessionCell
        cell.configure(groups[sortedKeys[indexPath.section]]?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return sortedKeys[section]
    }
    
}
