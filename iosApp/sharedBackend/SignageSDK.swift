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
    var sessions: [Session]? = nil
    var sessionOverviews: [SessionOverviewItem]? = nil
    
    // MARK: - Loading
    
    func loadRooms(reload: Bool = false, completion: ((_ rooms: [String]) -> Void)?) {
        loadSessions(reload: reload) { (sessions: [Session]) in
            var foundRooms: [String] = []
            for nextSession in sessions {
                if !foundRooms.contains(nextSession.location) {
                    foundRooms.append(nextSession.location)
                }
            }
            completion?(foundRooms)
        }
    }
    
    func loadSessionOverviews(reload: Bool = false, completion: ((_ sessionOverItems: [SessionOverviewItem]) -> Void)?) {
        if let results = sessionOverviews {
            completion?(results)
            return
        }
        sdk.getSessionOverviews(forceReload: reload) { [weak self] (sessionOverItems, error) in
            self?.sessionOverviews = sessionOverItems
            completion?(sessionOverItems ?? [])
        }
    }
    
    func loadSessions(reload: Bool = false, completion: ((_ sessionItems: [Session]) -> Void)?) {
        if let results = sessions {
            completion?(results)
            return
        }
        sdk.getSessions(forceReload: reload) { [weak self] (sessions: [Session]?, error: Error?) in
            self?.sessions = sessions
            completion?(sessions ?? [])
        }
    }
    
    func loadSessionsForRoom(_ room: String, reload: Bool = false, completion: ((_ sessionItems: [SessionOverviewItem]) -> Void)?) {
        sdk.getSessionOverviewsForLocation(location: room) { (sessionOverviewItems: [SessionOverviewItem]?, error: Error?) in
            completion?(sessionOverviewItems ?? [])
        }
    }
    
    func loadSessionForId(_ sessionID: String, completion: ((_ session: Session?) -> Void)?) {
        sdk.getSessionWithId(sessionId: sessionID) { (session : Session?, error: Error?) in
            completion?(session)
        }
    }

}
