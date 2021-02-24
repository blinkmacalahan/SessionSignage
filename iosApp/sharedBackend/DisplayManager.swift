//
//  DisplayManager.swift
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

class DisplayManager {
    
    // MARK: - Shared Manager
    static var shared: DisplayManager?
    
    // MARK: - Enum
    enum DisplayingScreen {
        case SessionDetails
        case RoomDetails
    }

    // MARK: - Class Variables
    var availableSessions: [SessionOverviewItem]?
    var displaySession: SessionOverviewItem?
    var showingRoom: String?
    var initialController: UIViewController?
    private var currentShowingScreen: DisplayingScreen = .SessionDetails
    private var loopCount = 0
    
    convenience init(session: SessionOverviewItem) {
        self.init()
        DisplayManager.shared = self
        availableSessions = [session]
    }
    
    convenience init(room: String) {
        self.init()
        DisplayManager.shared = self
        showingRoom = room
        SignageSDK.shared.loadSessionsForRoom(room) { [weak self] (sessionItems: [SessionOverviewItem]) in
            self?.availableSessions = sessionItems
        }
    }
    
    // MARK: - Display
    
    func displayFirstScreen(from controller: UIViewController) {
        initialController = controller
        if showingRoom == nil {
            showSessionController(from: controller, present: true)
        } else {
            showRoomController(from: controller, present: true)
        }
    }
    
    func displayNextScreen(from controller: UIViewController) -> Bool {
        if showingRoom == nil {
            // We are displaying only one session so we are on the correct controller.
            return false
        }
        switch currentShowingScreen {
        case .SessionDetails:
            showRoomController(from: controller, present: false)
        case .RoomDetails:
            if availableSessions?.count ?? 0 > 0 {
                showSessionController(from: controller, present: false)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func dismissDisplay(from controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func showSessionController(from controller: UIViewController, present: Bool) {
        currentShowingScreen = .SessionDetails
        
        // Figure out which session we are showing
        loopCount += 1
        var showingSession: SessionOverviewItem?
        if displaySession == nil {
            showingSession = availableSessions?.first
        } else if loopCount > 2 {
            loopCount = 1
            let index = availableSessions?.firstIndex(of: displaySession!) ?? 0
            let nextIndex = index + 1
            if nextIndex >= availableSessions?.count ?? 0 {
                showingSession = availableSessions?.first
            } else {
                showingSession = availableSessions?[nextIndex]
            }
        } else {
            showingSession = displaySession
        }
        displaySession = showingSession
        
        // Load session details with the provided session
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sessionDetailsController = storyboard.instantiateViewController(withIdentifier: "SessionDetailsViewController") as? SessionDetailsViewController else {
            fatalError("Unable to instatiate a SessionDetailsViewController from the storyboard.")
        }
        sessionDetailsController.sessionID = displaySession?.id
        if present {
            let navigationController = UINavigationController(rootViewController: sessionDetailsController)
            navigationController.setNavigationBarHidden(true, animated: false)
            let baseController = controller.presentingViewController ?? controller
            baseController.navigationController?.present(navigationController, animated: true, completion: nil)
        } else {
            controller.navigationController?.pushViewController(sessionDetailsController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                controller.navigationController?.viewControllers = [sessionDetailsController]
            }
        }
    }
    
    private func showRoomController(from controller: UIViewController, present: Bool) {
        currentShowingScreen = .RoomDetails
        
        // Load the room details
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let roomDetailsViewController = storyboard.instantiateViewController(withIdentifier: "RoomDetailsViewController") as? RoomDetailsViewController else {
            fatalError("Unable to instatiate a RoomDetailsViewController from the storyboard.")
        }
        roomDetailsViewController.room = showingRoom ?? ""
        roomDetailsViewController.sessions = availableSessions
        if present {
            let navigationController = UINavigationController(rootViewController: roomDetailsViewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            let baseController = controller.presentingViewController ?? controller
            baseController.navigationController?.present(navigationController, animated: true, completion: nil)
        } else {
            controller.navigationController?.pushViewController(roomDetailsViewController, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                controller.navigationController?.viewControllers = [roomDetailsViewController]
            }
        }
    }
    
}
