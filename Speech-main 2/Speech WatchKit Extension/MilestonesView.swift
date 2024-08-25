import SwiftUI
import UserNotifications
import Combine

struct MilestonesView: View {
    @State var Time = 0.0
    @State var TimeDone = 0.0
    @State var MilestoneTime : [Double] = []
    @State private var opacityStop = 0.0
    @State private var opacityStart = 1.0
    @State private var opacitySet = 1.0
    @State private var milestoneDots: [(x: Double, y: Double)] = []
    @State private var selectedMilestoneIndex: Int? = nil
    
    var body: some View {
        VStack {
            ZStack {
                Circle().stroke(
                    Color.white,
                    lineWidth: 3
                ).frame(
                    width: 100,
                    height: 90,
                    alignment: .center
                ).overlay(
                    Circle().trim(
                        from: 0.0,
                        to : CGFloat(
                            Time / TimeDone
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
                
                // Disegna i pallini per ogni milestone
                ForEach(0..<milestoneDots.count, id: \.self) { index in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: milestoneDots[index].x, y: milestoneDots[index].y)
                }
                
                Text("\(Int(Time))")
                    .focusable(true)
                    .digitalCrownRotation($Time, from: 0.0, through: TimeDone, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    .frame(width: 90, height: 90, alignment: .center)
                    .onChange(of: Time) { newValue in
                        if let index = MilestoneTime.firstIndex(where: { abs($0 - newValue) < 1.0 }) {
                            selectedMilestoneIndex = index
                        } else {
                            selectedMilestoneIndex = nil
                        }
                    }
            }
            
            HStack(spacing: 16) {
                // Modifica il pulsante "Set" / "Remove"
                if let index = selectedMilestoneIndex {
                    Text("Remove")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(
                                cornerRadius: 22,
                                style: .continuous
                            ).foregroundColor(.red)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .opacity(opacitySet)
                        .onTapGesture {
                            removeMilestone(at: index)
                        }
                } else {
                    Text("Set")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        .opacity(opacitySet)
                        .onTapGesture {
                            setMilestone()
                        }
                }
                
                // Bottone "Next" rimane invariato
                NavigationLink(destination: ListaTimer(TimerLista: TimeDone).environmentObject(UserData())) {
                    Text("Next")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                }
                .background(RoundedRectangle(cornerRadius: 22).stroke(Color.white, lineWidth: 2))
            }
            .frame(height: 50)
            .padding(.horizontal, 16)
        }
        .padding(.top, 10)
        .navigationBarTitle("Milestones")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func setMilestone() {
        self.MilestoneTime.append(self.Time)
        
        // Calcola la posizione del pallino sulla fine del cerchio
        let angle = (Time / TimeDone) * 360
        let radians = angle * Double.pi / 180
        let x = cos(radians) * 45 // 45 è il raggio del cerchio
        let y = sin(radians) * 45
        
        // Aggiungi la nuova posizione all'array dei pallini
        milestoneDots.append((x: x, y: y))
       
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        notificationContent.title = "It has been \(ceil((self.Time*100)/100)) minutes"

        notificationContent.body = "Milestone of \(ceil((self.Time*100)/100)) minutes"
        notificationContent.badge = NSNumber(value: 1)
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.Time * 60, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        NotificationArray.append(request)
        print("Added at time \(self.Time)")
        TimeSetted = true
    }
    
    func removeMilestone(at index: Int) {
        MilestoneTime.remove(at: index)
        milestoneDots.remove(at: index)
        selectedMilestoneIndex = nil // Reset the selection after removal
    }
}

struct MilestonesView_Previews: PreviewProvider {
    static var previews: some View {
        Group() {
            MilestonesView()
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            MilestonesView()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
    }
}

struct Arc : Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: 0, y: 0), radius: rect.width, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}
