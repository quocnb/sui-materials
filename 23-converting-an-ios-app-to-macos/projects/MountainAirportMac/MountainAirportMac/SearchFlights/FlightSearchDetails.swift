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

struct FlightSearchDetails: View {
	@SceneStorage("lastViewedFlightId") var lastViewedFlightID: Int?
	
  var flight: FlightInformation
  @Binding var showModal: Bool
  @State private var rebookAlert = false
  @State private var phone = ""
  @State private var password = ""
  @State private var checkInFlight: CheckInInfo?
  @State private var showCheckIn = false
  @State private var showFlightHistory = false
  @EnvironmentObject var lastFlightInfo: AppEnvironment

  var body: some View {
    ZStack {
      Image("background-view")
        .resizable()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      VStack(alignment: .leading) {
        HStack {
          FlightDetailHeader(flight: flight)
          Spacer()
          Button("Close") {
            showModal = false
          }
        }
        if flight.status == .canceled {
          Button("Rebook Flight") {
            rebookAlert = true
          }
          .alert("Contact Your Airline", isPresented: $rebookAlert) {
            TextField("Phone", text: $phone)
            SecureField("Password", text: $password)
            Button("Call Me") {
            }
            Button("Cancel", role: .cancel) {
            }
          } message: {
            Text("We cannot rebook this flight. Please contact") +
            Text(" the airline to reschedule this flight.")
					}.foregroundStyle(.primary)
        }
        if flight.isCheckInAvailable {
          Button("Check In for Flight") {
            checkInFlight =
              CheckInInfo(
                airline: flight.airline,
                flight: flight.number
              )
            showCheckIn = true
          }
          .confirmationDialog(
            "Check In",
            isPresented: $showCheckIn,
            presenting: checkInFlight
          ) { checkIn in
            Button("Check In") {
              print(
                "Check-in for \(checkIn.airline) \(checkIn.flight)."
              )
            }
            Button("Reschedule", role: .destructive) {
              print("Reschedule flight.")
            }
            Button("Not Now", role: .cancel) { }
          } message: { checkIn in
            Text("Check in for \(checkIn.airline)" +
              "Flight \(checkIn.flight)")
          }
        }
        Button("On-Time History") {
          showFlightHistory.toggle()
				}.popover(isPresented: $showFlightHistory, content: {
					FlightTimeHistory(flight: flight)
				})
				
        FlightInfoPanel(flight: flight)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 20.0)
              .opacity(0.3)
          )
        Spacer()
      }
      .foregroundColor(.white)
      .padding()
    }
		.frame(width: 400, height: 600)
    .interactiveDismissDisabled()
    .onAppear {
      lastViewedFlightID = flight.id
    }
  }
}

struct FlightSearchDetails_Previews: PreviewProvider {
  static var previews: some View {
    FlightSearchDetails(
      flight: FlightData.generateTestFlight(date: Date()),
      showModal: .constant(true)
    )
    .environmentObject(AppEnvironment())
  }
}
