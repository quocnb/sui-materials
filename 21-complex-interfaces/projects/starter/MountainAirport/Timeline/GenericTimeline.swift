/// Copyright (c) 2024 Kodeco Inc
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct GenericTimeline<Content, T>: View where Content: View {
	let events: [T]
	let timeProperty: KeyPath<T, Date>
	let content: (T) -> Content
	
	init(events: [T], timeProperty: KeyPath<T, Date>, @ViewBuilder content: @escaping (T) -> Content) {
		self.events = events
		self.timeProperty = timeProperty
		self.content = content
	}
	
	var earliestHour: Int {
		let flightsAscending = events.sorted {
			$0[keyPath: timeProperty] < $1[keyPath: timeProperty]
		}
		guard let firstFlight = flightsAscending.first else { return 0 }
		let hour = Calendar.current.component(.hour, from: firstFlight[keyPath: timeProperty])
		return hour
	}
	
	var latestHour: Int {
		let flightsAscending = events.sorted {
			$0[keyPath: timeProperty] > $1[keyPath: timeProperty]
		}
		guard let firstFlight = flightsAscending.first else { return 24 }
		let hour = Calendar.current.component(.hour, from: firstFlight[keyPath: timeProperty])
		return hour + 1
	}
	
	func eventsInHour(_ hour: Int) -> [T] {
		return events.filter {
			let flightHour = Calendar.current.component(.hour, from: $0[keyPath: timeProperty])
			return flightHour == hour
		}
	}
	
	func hourString(_ hour: Int) -> String {
		let tcmp = DateComponents(hour: hour)
		if let time = Calendar.current.date(from: tcmp) {
			return shortTimeFormatter.string(from: time)
		}
		return "Unknown"
	}
	
    var body: some View {
			ScrollView {
				VStack(alignment: .leading) {
					ForEach(earliestHour..<latestHour, id: \.self) { hour in
						let hourFlights = eventsInHour(hour)
						Text(hourString(hour))
							.font(.title2)
						ForEach(hourFlights.indices, id: \.self) { index in
							content(hourFlights[index])
						}
					}
				}
			}
    }
}

#Preview {
	GenericTimeline(events: FlightData.generateTestFlights(date: .now), timeProperty: \.localTime) { flight in
		FlightCardView(flight: flight)
	}
}
