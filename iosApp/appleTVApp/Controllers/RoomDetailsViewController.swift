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

class RoomDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var roomTitleLabel: UILabel!
    
    // MARK: - Variables
    var room: String = ""
    var sessions: [SessionOverviewItem]?
    private var menuPressRecognizer: UITapGestureRecognizer?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRoomInfo()
        if sessions == nil {
            SignageSDK.shared.loadSessionsForRoom(room) { [weak self] (overviewItems: [SessionOverviewItem]) in
                self?.sessions = overviewItems
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let weakSelf = self else { return }
            _ = DisplayManager.shared?.displayNextScreen(from: weakSelf)
        }
        
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
        roomTitleLabel.text = room
    }
    
    // MARK: - User Actions

    @objc func menuButtonAction() {
        DisplayManager.shared?.dismissDisplay(from: self)
    }

}
