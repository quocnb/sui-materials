/// Copyright (c) 2023 Kodeco Inc.
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

struct HierarchicalFlightRow: Identifiable {
	var label: String
	var flight: FlightInformation?
	var children: [HierarchicalFlightRow]?
	
	var id = UUID()
}

struct SearchFlights: View {
	var flightData: [FlightInformation]
	@State private var date = Date()
	@State private var directionFilter: FlightDirection = .none
	// Search key: City
	@State private var city = ""
	
	var matchingFlights: [FlightInformation] {
		var matchingFlights = flightData
		
		if directionFilter != .none {
			matchingFlights = matchingFlights.filter {
				$0.direction == directionFilter
			}
		}
		if !city.isEmpty {
			matchingFlights = matchingFlights.filter {
				$0.otherAirport.lowercased().contains(city.lowercased())
			}
		}
		return matchingFlights
	}
	
	
	/// Create a hierarchicalFlightRow from the flight information
	/// - Parameter flight: the flight information
	/// - Returns: an HierrachicalFlightRow
	func hierarchicalFlightRowFromFlight(_ flight: FlightInformation) -> HierarchicalFlightRow {
		HierarchicalFlightRow(label: longDateFormatter.string(from: flight.localTime), flight: flight, children: nil)
	}
	
	var flightDates: [Date] {
		let allDates = matchingFlights.map { $0.localTime.dateOnly }
		let uniqueDates = Array(Set(allDates))
		return uniqueDates.sorted()
	}
	
	func flightsForDay(date: Date) -> [FlightInformation] {
		matchingFlights.filter {
			Calendar.current.isDate($0.localTime, inSameDayAs: date)
		}
	}
	
	/// Flights List that grouped by Date
	var hierarchicalFlights: [HierarchicalFlightRow] {
		var rows = [HierarchicalFlightRow]()
		
		for date in flightDates {
			let newRow = HierarchicalFlightRow(
				label: longDateFormatter.string(from: date),
				children: flightsForDay(date: date).map {hierarchicalFlightRowFromFlight($0)})
			rows.append(newRow)
		}
		return rows
	}

  var body: some View {
    ZStack {
      Image("background-view")
        .resizable()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      VStack {
        Picker(
          selection: $directionFilter,
          label: Text("Flight Direction")
        ) {
          Text("All").tag(FlightDirection.none)
          Text("Arrivals").tag(FlightDirection.arrival)
          Text("Departures").tag(FlightDirection.departure)
        }
				.background(.white)
				.cornerRadius(9.0)
        .pickerStyle(SegmentedPickerStyle())
        // Insert Results
//				List(hierarchicalFlights, children: \.children) { row in
//					if let flight = row.flight {
//						SearchResultRow(flight: flight)
//					} else {
//						Text(row.label)
//					}
//				}
				List {
					ForEach(flightDates, id: \.hashValue) { date in
						Section {
							ForEach(flightsForDay(date: date)) { flight in
								SearchResultRow(flight: flight)
							}
						} header: {
							Text(longDateFormatter.string(from: date))
						} footer: {
							Text("Matching flights \(flightsForDay(date:date).count)")
								.frame(maxWidth: .infinity, alignment: .trailing)
						}

					}
				}
				.listStyle(InsetGroupedListStyle())
      }
			.searchable(text: $city)
      .navigationBarTitle("Search Flights")
      .padding()
    }
  }
}

struct SearchFlights_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      SearchFlights(flightData: FlightData.generateTestFlights(date: Date())
      )
    }
  }
}
