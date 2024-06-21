//
//  ContentView.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-18.
//

import SwiftUI
import SwiftData

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(Color.black, lineWidth: 3)
        ).padding()
    }
}

struct ContentView: View {
    @StateObject var viewModel: EventViewModel
    @State private var selectedDate: Date = Date().addingTimeInterval(86400)
    @State private var eventName: String = ""
    @State private var showAlert = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private func addEvent() {
        if eventName == "" {
            showAlert = true
            return
        }
        viewModel.addEvent(name: eventName, date: selectedDate)
    }
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: EventViewModel(context: modelContext))
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Type in event name here:")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .fontDesign(.rounded)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                TextField("Enter event name", text: $eventName)
                    .border(.white)
                    .textFieldStyle(MyTextFieldStyle())
                    .padding(.horizontal, 30)
                    .onChange(of: eventName) { _, newValue in
                        showAlert = newValue == ""
                    }
                if (showAlert) {
                    Text("Event name is required").fontDesign(.monospaced).foregroundStyle(.red)
                }
                DatePicker("Select a date", selection: $selectedDate, in: Date().addingTimeInterval(86400)..., displayedComponents: [.date, .hourAndMinute])
                Button("Add Event") {
                    addEvent()
                }.fontDesign(.rounded)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .foregroundStyle(.white)
            }.padding()
            List {
                ForEach(viewModel.activeList) { event in
                    let timeInSec = event.getSecFromNow()
                    let components = Util.convertSecondsToComponents(timeInSec: timeInSec)
                    VStack {
                        Text(event.name)
                        HStack {
                            Text(event.date.convertToString())
                            Text("\(components.0) days \(components.1) hours, \(components.2) minutes \(components.3) seconds")
                        }
                    }
                }.onDelete(perform: { indexSet in
                    self.viewModel.removeEvent(indexSet: indexSet)
                })
            }.onReceive(timer, perform: { _ in
                self.viewModel.objectWillChange.send()
            })
        }.onAppear{
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .notDetermined {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        DispatchQueue.main.async {
                            viewModel.shouldNotify = granted
                        }
                        if let error = error {
                            print("Authorization error: \(error.localizedDescription)")
                        }
                    }
                } else {
                    viewModel.shouldNotify = settings.authorizationStatus == .authorized
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Event.self)
    return ContentView(modelContext: container.mainContext)
}
