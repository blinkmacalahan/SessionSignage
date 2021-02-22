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
        }
    }
}

extension SessionItem: Identifiable { }
