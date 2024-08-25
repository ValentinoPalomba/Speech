import SwiftUI
import UserNotifications
import Combine

struct TimerFinale: View {
    @State var timeTimer = 0
    @State private var isTimerRunning = false
    @State private var showSaveButton = false
    @State private var showAlert = false
    @State private var timePassed: Double = 0.0
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            timerDisplay
            controlButtons
        }
        .padding(.top)
        .navigationBarTitle("Good luck!")
    }
}

// MARK: - Subviews

extension TimerFinale {
    private var timerDisplay: some View {
        ZStack {
            Circle().stroke(Color.white, lineWidth: 3)
                .frame(width: 90, height: 90)
                .overlay(
                    Circle().trim(
                        from: 0.0,
                        to : CGFloat(
                            timePassed / Double(timeTimer)
                        )
                    ).stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth : 3,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    ).frame(
                        width: 90,
                        height: 90,
                        alignment: .center
                    )
                )
            Text("\(timeTimer)")
                .font(.largeTitle)
                .focusable(true)
        }
    }
    
    private var controlButtons: some View {
        HStack {
            if isTimerRunning {
                stopButton
            } else {
                startButton
            }
        }
        .animation(.easeInOut, value: isTimerRunning)
    }
    
    private var startButton: some View {
        Button(action: startTimer) {
            Text("Start")
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding(.horizontal, 16)
    }
    
    private var stopButton: some View {
        Button(action: stopTimer) {
            Text("Stop")
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding(.horizontal, 16)
    }
    
    private var saveButton: some View {
        Button(action: saveTimer) {
            Text("Save")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
        .opacity(showSaveButton ? 1.0 : 0.0)
    }
    
    private var hiddenNavigationLinks: some View {
        HStack {
            NavigationLink(destination: ListaTimerModifica(), isActive: .constant(false)) {
                EmptyView()
            }
            NavigationLink(destination: ListaTimerSelezione().environmentObject(userData), isActive: .constant(false)) {
                EmptyView()
            }
        }
        .hidden()
    }
    
    private var contextMenuItems: some View {
        Group {
            Button(action: createNewTimer) {
                Text("Create a new timer")
            }
            NavigationLink(destination: ListaTimerModifica().environmentObject(userData)) {
                Text("Modify an existing timer")
            }
            Button(action: selectExistingTimer) {
                Text("Select an existing timer")
            }
        }
    }
}

// MARK: - Actions

extension TimerFinale {
    private func startTimer() {
        isTimerRunning = true
        showSaveButton = false
        
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            if timeTimer > 0 {
                timeTimer -= 1
                print("Timer decrementing: \(timeTimer)")
                timePassed += 1
            } else {
                stopTimer()
            }
        }
        
        NotificationArray.forEach { notification in
            UNUserNotificationCenter.current().add(notification) { error in
                if let error = error {
                    print("Notification error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func stopTimer() {
        isTimerRunning = false
        showSaveButton = timeTimer > 0
        TimeSetted = false
    }
    
    private func saveTimer() {
        let newTimer = ListElementSaved(name: "Timer", timerString: "\(timeTimer)", timerDouble: Double(timeTimer))
        userData.listElementsSaved.append(newTimer)
        print("Timer saved: \(newTimer)")
    }
    
    private func createNewTimer() {
        // Logic to create a new timer
    }
    
    private func selectExistingTimer() {
        // Logic to select an existing timer
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                ).foregroundColor(.blue)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct TimerFinale_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerFinale()
                .previewDevice("Apple Watch Series 6 - 44mm")
                .environmentObject(UserData())
            
            TimerFinale()
                .previewDevice("Apple Watch Series 6 - 40mm")
                .environmentObject(UserData())
        }
    }
}
