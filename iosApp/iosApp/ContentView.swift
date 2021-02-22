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
            text.append("\n")
        }
        return Text(text)
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        let sdk: SessionSignageSDK
        @Published var sessions: [SessionItem]? = nil
        
        init(sdk: SessionSignageSDK) {
            self.sdk = sdk
            self.loadSessions()
        }
        
        func loadSessions() {
            sdk.getSessions(forceReload: false, completionHandler: {sessions, error in
                self.sessions = sessions
            })
        }
    }
}

extension SessionItem: Identifiable { }
