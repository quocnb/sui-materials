/// Copyright (c) 2023 Kodeco Inc
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

struct FlightStatusBoard: View {
  @State var flights: [FlightInformation]
  var flightToShow: FlightInformation?
  @State private var hidePast = false
  @AppStorage("FlightStatusCurrentTab") var selectedTab = 1
	// An array with the id of each flight the user highlights
	@State var highlightedIds: [Int] = []

  var shownFlights: [FlightInformation] {
    hidePast ?
      flights.filter { $0.localTime >= Date() } :
      flights
  }

	func lastUpdateString(_ date: Date) -> String {
		let dateF = DateFormatter()
		dateF.timeStyle = .short
		dateF.dateStyle = .none
		return "Last update: \(dateF.string(from: date))"
	}

  var body: some View {
		TimelineView(.everyMinute, content: { context in
			VStack {
				Text(lastUpdateString(context.date))
					.font(.footnote)
				TabView(selection: $selectedTab) {
					FlightList(
						flights: shownFlights.filter { $0.direction == .arrival },
						highlightedIds: $highlightedIds
					)
					.tabItem {
						Image("descending-airplane")
							.resizable()
						Text("Arrivals")
					}
					.tag(0)
					FlightList(
						flights: shownFlights,
						flightToShow: flightToShow,
						highlightedIds: $highlightedIds
					)
					.tabItem {
						Image(systemName: "airplane")
							.resizable()
						Text("All")
					}
					.tag(1)
					FlightList(
						flights: shownFlights.filter { $0.direction == .departure },
						highlightedIds: $highlightedIds
					)
					.tabItem {
						Image("ascending-airplane")
						Text("Departures")
					}
					.tag(2)
				}
				.onAppear {
					if flightToShow != nil {
						selectedTab = 1
					}
				}
				.refreshable(action: {
					await self.flights = FlightData.refreshFlights()
				})
				.navigationTitle("Today's Flight Status")
				.navigationBarItems(
					trailing: Toggle("Hide Past", isOn: $hidePast)
			)
			}
		})
  }
}

struct FlightStatusBoard_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      FlightStatusBoard(
        flights: FlightData.generateTestFlights(date: Date())
      )
    }
    .environmentObject(FlightNavigationInfo())  }
}
