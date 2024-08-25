import SwiftUI
import UserNotifications
import Combine

struct ContentView: View {
    @State private var time = 0.0
    @State private var milestoneTime = [Double]()
    @State private var listaTimerModify = false
    @State private var listaTimerSelect = false
    @State private var tappable = false
    @State private var opacityStart = 1.0
    @State private var opacityStop = 0.0
    @State private var opacitySet = 0.0
    @State private var showMessage: Bool = !UserDefaults.standard.bool(forKey: "MessageShown")
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle().trim(
                            from: 0.0,
                            to : CGFloat(
                                time / 60
                            )
                        ).stroke(
                            Color.blue,
                            style: StrokeStyle(
                                lineWidth : 3,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                    )
                
                Text("\(Int(time))")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .monospacedDigit()
                    .focusable(true)
                    .digitalCrownRotation(
                        $time,
                        from: 0.0,
                        through: 60,  // Assuming a maximum of 1 hour
                        by: 1.0,
                        sensitivity: .low,
                        isContinuous: false,
                        isHapticFeedbackEnabled: true
                    )
                
            }
            .padding(.vertical, 16)
            
            NavigationLink(destination: MilestonesView(TimeDone: time)) {
                Text("Set")
                    .font(.system(size: 14))
                    .opacity(opacityStart)
                
                
            }
            .background(RoundedRectangle(cornerRadius: 22).stroke())
            .padding(.horizontal, 16)
            
            
        }
        
        .navigationBarTitle(showMessage ? "" : "Speech Duration")
        .navigationViewStyle(.automatic)
        .withContextMenu(listaTimerModify: $listaTimerModify, listaTimerSelect: $listaTimerSelect, time: time)
        .onAppear {
            NotificationArray.removeAll()
        }
        .overlay(InfographicView(showMessage: $showMessage), alignment: .center)
    }
}

extension View {
    func withContextMenu(listaTimerModify: Binding<Bool>, listaTimerSelect: Binding<Bool>, time: Double) -> some View {
        self.modifier(ContextMenuNavigator(listaTimerModify: listaTimerModify, listaTimerSelect: listaTimerSelect, time: time))
    }
}


struct ContextMenuNavigator: ViewModifier {
    internal init(listaTimerModify: Binding<Bool>, listaTimerSelect: Binding<Bool>, time: Double) {
        self._listaTimerModify = listaTimerModify
        self._listaTimerSelect = listaTimerSelect
        self.time = time
    }
    
    
    @Binding private var listaTimerModify: Bool
    @Binding private var listaTimerSelect: Bool
    var time: Double
    
    
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                NavigationLink(destination: SaveTimerView(name: "", timerString: "\(Int(time))", timerDouble: time)) {
                    Text("Create a new timer")
                }
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
                NavigationLink(
                    destination: ListaTimerModifica().environmentObject(UserData()),
                    isActive: $listaTimerModify
                ) {
                    Text("Modify an existing timer")
                }
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
                NavigationLink(
                    destination: ListaTimerSelezione().environmentObject(UserData()),
                    isActive: $listaTimerSelect
                ) {
                    Text("Select an existing timer")
                }
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }

    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            ContentView()
                .previewDevice("Apple Watch Series 5 - 40mm")
            
            MilestonesView()

            ListaTimer()
                .environmentObject(UserData())
            
            ListaTimerSelezione()
                .environmentObject(UserData())
            
            ListaTimerModifica()
                .environmentObject(UserData())
            
            TimerFinale()
                .environmentObject(UserData())
        }
    }
}

struct InfographicView: View {
    @Binding var showMessage: Bool
    var body: some View {
        if showMessage {
            VStack {
                Spacer()
                Text("For a better experience, we recommend enabling silent mode and locking the Apple Watch once the timer has started.")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(10)
                    .padding()
                    .transition(.move(edge: .bottom))
                    
                Spacer()
                Button(action: {
                    // Dismiss the message
                    withAnimation {
                        showMessage = false
                    }
                    // Save the state
                    UserDefaults.standard.set(true, forKey: "MessageShown")
                }) {
                    Text("Got it")
                        .font(.headline)
                        
                }
                .buttonStyle(PrimaryButtonStyle())
                Spacer()
            }
            .padding()
            .background(Color.black.opacity(0.9))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
