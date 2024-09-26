import SwiftUI

struct BeaconPage: View {
    
    @StateObject private var detector = BeaconDetectionViewModel()
    //@StateObject private var detector = BeaconDetectorViewModel()
    
    var body: some View {
        Text("Nearest beacon")
        Text(detector.currentNearestLocation?.location ?? "unknown")
    }
}

#Preview {
    BeaconPage()
}
