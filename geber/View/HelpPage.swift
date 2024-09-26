import SwiftUI

struct HelpPage: View {
    @StateObject private var viewmodel = HelpViewModel()
    
    var body: some View{
        VStack{
            if viewmodel.isSent != true {
                Spacer()
                LocationSection(currentNearestLocation: $viewmodel.currentNearestLocation)
            }
            Spacer()
            ImageLocation(currentNearestLocation: $viewmodel.currentNearestLocation)
            Spacer()
            if viewmodel.currentNearestLocation != nil {
                if viewmodel.isSent != true {
                    SliderSection(isSent: $viewmodel.isSent, timer: $viewmodel.timer, timeRemaining: $viewmodel.timeRemaining)
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
            .foregroundColor(.backgrundLayer)
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

struct SliderSection: View{
    @Binding var isSent:Bool
    
    @Binding var timer:Timer?
    @Binding var timeRemaining:TimeInterval
    
    var body: some View{
        HStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    SlideBackground()
                    Slide(
                        isSent: $isSent,
                        timer: $timer,
                        timeRemaining: $timeRemaining,
                        maxWidth: (geometry.size.width)
                    )
                }
            }
            .frame(height: 86)
        }
        .padding(.vertical, 16)
    }
}

struct Slide: View{
    @Binding var isSent:Bool
    
    @Binding var timer:Timer?
    @Binding var timeRemaining:TimeInterval
    
    let maxWidth: CGFloat
    
    private let minWidth = CGFloat(86)
    @State private var width = CGFloat(86)
    
    var body: some View{
        RoundedRectangle(cornerRadius: 43)
            .fill(.backgrundLayer)
            .frame(width: width)
            .overlay(
                ZStack(alignment: .center) {
                    image(name: "checkmark", isShown: isSent)
                    image(name: "arrow.right", isShown: !isSent)
                }
                    .padding(.trailing,8),
                alignment: .trailing
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 0 {
                            width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                        }
                    }
                    .onEnded { value in
                        if width < maxWidth {
                            width = minWidth
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        } else {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            setTimer()
                        }
                    }
            )
    }
    
    private func setTimer() {
        withAnimation(.spring().delay(0.5)){
            isSent = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    stopTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        withAnimation(.spring()){
            isSent = false
            timer?.invalidate()
            timeRemaining = 10
        }
    }
    
    private func image(name: String, isShown: Bool) -> some View {
        Image(systemName: name)
          .font(.system(size: 20, weight: .regular, design: .rounded))
          .frame(maxWidth: 70, maxHeight: 70)
          .background(RoundedRectangle(cornerRadius: 43).fill(.accent))
          .foregroundColor(.textDark)
          .opacity(isShown ? 1 : 0)
          .scaleEffect(isShown ? 1 : 0.01)
      }
}

struct SlideBackground: View {
    var body: some View {
        ZStack(alignment: .leading)  {
            RoundedRectangle(cornerRadius: 43)
                .fill(.backgrundLayer)

            Text("Slide to request help")
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding(.leading,68)
        }
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
        .background(.backgrundLayer)
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
