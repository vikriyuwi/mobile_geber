import SwiftUI

struct HelpPage: View {
    @StateObject private var viewModel = HelpViewModel()
    
    var body: some View{
        NavigationStack{
            VStack{
                if viewModel.isSent != true {
                    Spacer()
                    LocationSection(currentNearestLocation: $viewModel.currentNearestLocation)
                }
                Spacer()
                ImageLocation(currentNearestLocation: $viewModel.currentNearestLocation)
                Spacer()
                if viewModel.currentNearestLocation != nil {
                    if viewModel.isSent != true {
                        HelpDetailView()
                            .environmentObject(viewModel)
                    } else {
                        Text("Security is coming")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        Text("Don’t move into other location while security is coming to you to help")
                            .multilineTextAlignment(.center)
                        Countdown()
                            .environmentObject(viewModel)
                        Text("Wait for 1 minute before sending another request")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    HelpDetailView()
                        .environmentObject(viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
            .background(.backgroundTheme)
        }
        .navigationViewStyle(.stack)
    }
}

struct ImageLocation: View{
    @Binding var currentNearestLocation:BeaconModel?
    
    var body: some View{
        HStack{
            ZStack{
                Image("ParkingMark")
                    .resizable()
                    .scaledToFit()
                if currentNearestLocation != nil {
                    Image("Motorbike")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct LocationSection: View{
    @Binding var currentNearestLocation:BeaconModel?
    
    var body: some View{
        HStack{
            VStack{
                if currentNearestLocation != nil {
                    LocationFound(currentNearestLocation: $currentNearestLocation)
                } else {
                    LocationNotFound()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
    }
}

struct LocationNotFound: View{
    var body: some View{
        Text("?")
            .font(.system(size: 72, weight: .bold))
        Text("Location undetected")
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
        Text("Make sure you are in parking area and try to move around")
            .multilineTextAlignment(.center)
    }
}

struct LocationFound: View{
    @Binding var currentNearestLocation:BeaconModel?
    
    var body: some View{
        Text("Your position right now")
            .font(.title2)
            .multilineTextAlignment(.center)
        Text(currentNearestLocation?.location ?? "Unknown")
            .font(.system(size: 98, weight: .bold))
        Text(currentNearestLocation?.detailLocation ?? "Unknown")
            .multilineTextAlignment(.center)
    }
}

struct Countdown: View {
    
    @EnvironmentObject var viewModel:HelpViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text(formatedTime())
                    .font(.largeTitle.bold())
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(20)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.background)
        .cornerRadius(20)
        .padding(.vertical, 10)
    }
    
    private func formatedTime() -> String {
        let minute = Int(viewModel.timeRemaining)/60
        let second = Int(viewModel.timeRemaining)%60
        return String(format: "%02d : %02d", minute,second)
    }
}

#Preview {
    HelpPage()
}
