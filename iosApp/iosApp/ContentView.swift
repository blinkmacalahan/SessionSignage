import SwiftUI
import shared

func greet() -> String {
    return Greeting().greeting()
}

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        guard let sessions = viewModel.sessions, sessions.count > 0 else {
            return Text(greet())
        }
        
        var text = ""
        for session in sessions {
            text.append(session.name)
            text.append(": ")
            text.append(Platform().formatSessionTime(startTime: session.startTime, endTime: session.endTime))
            text.append("\n")
        }
        return Text(text)
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        let sdk: SessionSignageSDK
        @Published var sessions: [SessionOverviewItem]? = nil
        
        init(sdk: SessionSignageSDK) {
            self.sdk = sdk
            self.loadSessionOverviews()
        }
        
        func loadSessionOverviews() {
            sdk.getSessionOverviews(forceReload: false) { (sessionOverItems, error) in
                self.sessions = sessionOverItems
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
    }
}

extension SessionItem: Identifiable { }
