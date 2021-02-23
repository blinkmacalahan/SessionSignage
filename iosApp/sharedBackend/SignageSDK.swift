//
//  SignageSDK.swift
//  iosApp
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
//            // Code to be notified when a session is updated
//            sdk.getObservableSessionWithId(sessionId: "a8ca402e-c376-4daa-93df-6b5cf28b5537") { (commonFlow, error) in
//                commonFlow?.watch(block: { (session) in
//                    print("session: " + (session?.name ?? "not found"))
//
//                    if let xSession = session {
//                        self.sessions = [SessionOverviewItem(id: xSession.id, name: xSession.name, description: xSession.description(), startTime: xSession.startTime, endTime: xSession.endTime)]
//                    }
//                })
//            }
//
//            // Code to update a session to test the observer is working
//            sdk.updateSession(sessionId: "a8ca402e-c376-4daa-93df-6b5cf28b5537") { (any, error) in
//                print("update complete")
//            }


}
