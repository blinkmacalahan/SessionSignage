//
//  SignageSDK.swift
//  iosApp
//
//  Created by Justin Carstens on 2/23/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit
import shared

class SignageSDK {
    
    // MARK: - Shared Manager
    static let shared = SignageSDK()
    private init() {} // Making this private prevents others from using the default '()' initializer for this class.
    
    // MARK: - Variables
    let sdk: SessionSignageSDK = SessionSignageSDK(databaseDriverFactory: DatabaseDriverFactory())
    var sessions: [SessionOverviewItem]? = nil
    
    // MARK: - Loading
    
    func loadSessionOverviews() {
        sdk.getSessionOverviews(forceReload: false) { [weak self] (sessionOverItems, error) in
            self?.sessions = sessionOverItems
        }
    }
    
    // MARK: - Data
    
    func sessionText() -> String {
        guard let sessions = sessions, sessions.count > 0 else {
            return Greeting().greeting()
        }
        
        var text = ""
        for session in sessions {
            text.append(session.name)
            text.append(": ")
            text.append(Platform().formatSessionTime(startTime: session.startTime, endTime: session.endTime))
            text.append("\n")
        }
        return text
    }

}
