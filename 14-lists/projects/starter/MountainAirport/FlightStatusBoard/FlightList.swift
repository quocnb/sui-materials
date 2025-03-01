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

struct FlightList: View {
	var flights: [FlightInformation]
	@State var flightToShow: FlightInformation?
	@State private var path: [FlightInformation] = []
	var nextFlightId: Int {
		guard let flight = flights.first(where: { flightInfo in
			flightInfo.localTime >= Date()
		}) else {
			return flights.last?.id ?? 0
		}
		return flight.id
	}
	
	var body: some View {
		NavigationStack(path: $path) {
			ScrollViewReader(content: { proxy in
				List(flights) { flight in
					NavigationLink(value: flight) {
						FlightRow(flight: flight)
					}
				}
				.navigationDestination(for: FlightInformation.self) { flight in
					FlightDetails(flight: flight)
				}
				.onAppear(perform: {
					if flightToShow != nil {
						Task {
							// View must be appearing before go to the next view (Flight Detail)
							// So we must wait for 0.5 second to walk around this
							// 0.5 is min accepted value
							 try? await Task.sleep(for: .seconds(0.5))
							 path.append(flightToShow!)
						}
					}
				})
				.onDisappear(perform: {
					flightToShow = nil
				})
			})
			
		}
	}
}

struct FlightList_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			FlightList(
				flights: FlightData.generateTestFlights(date: Date())
			)
		}
		.environmentObject(FlightNavigationInfo())
	}
}
