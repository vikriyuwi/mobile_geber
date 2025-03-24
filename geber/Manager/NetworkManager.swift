import SwiftUI
import Network

class NetworkManager: ObservableObject {
    private let nerworkManager = NWPathMonitor()
    @Published var hasNetworkConnection = true
    
    init() {
        nerworkManager.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.setNetworkConnection(connection: path.status == .satisfied)
            print(path.status)
        }
        
        nerworkManager.start(queue: DispatchQueue.global())
    }
    
    private func setNetworkConnection(connection: Bool) {
        Task { @MainActor in
            withAnimation {
                hasNetworkConnection = connection
            }
        }
    }
}
