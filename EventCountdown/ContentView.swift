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
    @State private var eventName: String = ""
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private func addEvent() {
        viewModel.addEvent(name: eventName, date: selectedDate)
    }
    var body: some View {
        VStack {
            VStack {
                Text("Type in event name here:")
                TextField("Enter event name", text: $eventName).border(Color.black).padding(.leading, 30).padding(.trailing, 30).padding(.top, 20)
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute]).padding(.top, 20)
                Button("Add Event") {
                    addEvent()
                }.padding(.top, 20)
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
        }
    }
}

#Preview {
    ContentView()
}
