import SwiftUI

struct HelpPage: View {
    @StateObject private var viewmodel = HelpViewModel()
    
    var body: some View{
        NavigationStack{
            VStack{
                NavigationLink(destination: {
                    VehicleInformationPage()
                }, label: {
                    Text("Fill the data")
                })
                .buttonStyle(.borderedProminent)
                if viewmodel.isSent != true {
                    Spacer()
                    LocationSection(currentNearestLocation: $viewmodel.currentNearestLocation)
                }
                Spacer()
                ImageLocation(currentNearestLocation: $viewmodel.currentNearestLocation)
                Spacer()
                if viewmodel.currentNearestLocation != nil {
                    if viewmodel.isSent != true {
                        ButtonSection()
                            .environmentObject(viewmodel)
                    } else {
                        Text("Security is coming")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        Text("Don’t move into other location while security is coming to you to help")
                            .multilineTextAlignment(.center)
                        Countdown(timeRemaining: $viewmodel.timeRemaining)
                        Text("Wait for 1 minute before sending another request")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
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

struct ButtonSection: View{
    @EnvironmentObject var viewModel:HelpViewModel
    
    var body: some View{
        HStack {
            Button {
                viewModel.sendHelpRequest()
            } label: {
                HStack {
                    Text("Request a help")
                        .foregroundStyle(.white)
                }
                .background(Color.green)
            }
        }
        .padding(.vertical, 16)
        .frame(width: .infinity)
    }
}

struct Countdown: View {
    @Binding var timeRemaining:TimeInterval
    
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
        let minute = Int(timeRemaining)/60
        let second = Int(timeRemaining)%60
        return String(format: "%02d : %02d", minute,second)
    }
}

#Preview {
    HelpPage()
}
