//
//  ContentView.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-18.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = EventViewModel()
    @State private var selectedDate: Date = Date()
    @State private var eventName: String = "new event"
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private func addEvent() {
        viewModel.addEvent(name: eventName, date: selectedDate)
    }
    var body: some View {
        VStack {
            VStack {
                TextField("Enter event name", text: $eventName)
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                Button("Add Event") {
                    addEvent()
                }
            }
            List(viewModel.eventList, id: \.id, rowContent: { event in
                let components = Util.convertSecondsToComponents(timeInSec: event.getSecFromNow())
                VStack {
                    Text(event.name)
                    HStack {
                        Text(event.date.convertToString())
                        Text("\(components.0) days \(components.1) hours, \(components.2) minutes \(components.3) seconds")
                    }
                }
            }).onReceive(timer) { _ in
                self.viewModel.objectWillChange.send()
            }
        }
    }
}

#Preview {
    ContentView()
}
