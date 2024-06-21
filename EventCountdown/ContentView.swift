//
//  ContentView.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-18.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var viewModel: EventViewModel
    @State private var selectedDate: Date = Date()
    @State private var eventName: String = ""
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private func addEvent() {
        viewModel.addEvent(name: eventName, date: selectedDate)
    }
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: EventViewModel(context: modelContext))
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Type in event name here:")
                TextField("Enter event name", text: $eventName).border(Color.black).padding(.leading, 30).padding(.trailing, 30)
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                Button("Add Event") {
                    addEvent()
                }.background(Color.red).font(.callout)
            }
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

//#Preview {
//    let container = ModelContainer(for: Event.self)
//    ContentView(modelContext: container.mainContext)
//}
