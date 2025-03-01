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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct FlightDetails: View {
	@SceneStorage("lastViewedFlightID") var lastViewedFlightID: Int?
	
  var flight: FlightInformation?
  @State private var showTerminalInfo = false
  @EnvironmentObject var lastFlightInfo: AppEnvironment

  var body: some View {
    ZStack {
      Image("background-view")
        .resizable()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
			if let flight {
				VStack(alignment: .leading) {
					FlightDetailHeader(flight: flight)
					FlightInfoPanel(flight: flight)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 20.0)
								.opacity(0.3)
						)
					Spacer()
				}
				.foregroundColor(.white)
				.padding()
			.navigationTitle("\(flight.airline) Flight \(flight.number)")
			} else {
				Text("Select a flight")
					.foregroundStyle(.white)
			}
    }
		.frame(minWidth: 400, minHeight: 400)
    .contentShape(Rectangle())
    .onTapGesture {
      showTerminalInfo.toggle()
    }
    .sheet(isPresented: $showTerminalInfo) {
      Group {
        if flight?.terminal == "A" {
          TerminalAView()
        } else {
          TerminalBView()
        }
      }
      .presentationDetents([.medium, .large])
    }
		.onChange(of: flight, {
			lastViewedFlightID = flight?.id
		})
  }
}

struct FlightDetails_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      FlightDetails(
        flight: FlightData.generateTestFlight(date: Date())
      )
      .environmentObject(AppEnvironment())
    }
  }
}
