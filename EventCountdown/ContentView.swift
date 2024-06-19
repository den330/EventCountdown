//
//  ContentView.swift
//  EventCountdown
//
//  Created by yaxin on 2024-06-18.
//

import SwiftUI

class Event: Identifiable {
    var id = UUID()
    var secondsLeft: Int
    var name: String
    init(secondsLeft: Int, name: String) {
        self.secondsLeft = secondsLeft
        self.name = name
    }
}

class EventViewModel: ObservableObject {
    @Published var eventList: [Event] = [];
    func addEvent() {
        let secLeft = Int.random(in: 0..<60)
        let name = "Event" + UUID().uuidString.prefix(3)
        let event = Event(secondsLeft: secLeft, name: name)
        eventList.append(event)
    }
    
    func refreshTime() {
        for event in eventList {
            event.secondsLeft -= 1
        }
        eventList = eventList.filter { $0.secondsLeft > 0 }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = EventViewModel()
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Button("AddEvent", action: {
                viewModel.addEvent()
            })
            List(viewModel.eventList, id: \.id, rowContent: { item in
                HStack(alignment: .center) {
                    Text(item.name)
                    Text(String(item.secondsLeft))
                }
            }).onReceive(timer, perform: { _ in
                viewModel.refreshTime()
            })
            
        }
    }
}

#Preview {
    ContentView()
}
