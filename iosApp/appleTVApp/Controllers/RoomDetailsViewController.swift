//
//  RoomDetailsViewController.swift
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

class RoomDetailsViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var roomTitleLabel: UILabel?
    @IBOutlet weak var sessionsTableView: UITableView!
    
    // MARK: - Variables
    var room: String = ""
    var sessions: [Session]?
    private var menuPressRecognizer: UITapGestureRecognizer?
    private var animationTimer: Timer?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRoomInfo()
        if sessions == nil {
            SignageSDK.shared.loadSessionsForRoom(room) { [weak self] (roomSessions: [Session]) in
                DisplayManager.shared?.availableSessions = roomSessions
                self?.sessions = roomSessions
                self?.loadRoomInfo()
            }
        }
        
        // Add Menu Override
        menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer?.addTarget(self, action: #selector(menuButtonAction))
        menuPressRecognizer?.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
//            guard let weakSelf = self else { return }
//            _ = DisplayManager.shared?.displayNextScreen(from: weakSelf)
//        }
        
        // Add Menu Override
        if let menuAction = menuPressRecognizer {
            view.addGestureRecognizer(menuAction)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Menu Override
        if let menuAction = menuPressRecognizer {
            view.removeGestureRecognizer(menuAction)
        }
    }
    
    // MARK: - UI
    
    func loadRoomInfo() {
        roomTitleLabel?.text = room
        sessionsTableView.reloadData()
        
        if sessionsTableView.numberOfRows(inSection: 0) > 0 {
            sessionsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            Block.performOnMainThreadAfterDelay(5.0) {
                self.startAnimation()
            }
        }
    }
    
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
                    _ = DisplayManager.shared?.displayNextScreen(from: weakSelf2)
                }
                return
            }
            weakSelf.sessionsTableView.setContentOffset(CGPoint(x: currentOffset.x, y: currentOffset.y + 50), animated: true)
        })
    }
    
    // MARK: - User Actions

    @objc func menuButtonAction() {
        DisplayManager.shared?.dismissDisplay(from: self)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoomSessionCell = tableView.dequeueReusableCell(withIdentifier: "RoomSessionCell", for: indexPath) as! RoomSessionCell
        cell.configure(sessions?[indexPath.row])
        return cell
    }

}
