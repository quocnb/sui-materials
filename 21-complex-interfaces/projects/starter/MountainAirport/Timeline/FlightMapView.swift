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
import MapKit

class MapCoordinator: NSObject {
	var mapView: FlightMapView
	var fraction: CGFloat
	
	init(mapView: FlightMapView, fraction: CGFloat = 0.0) {
		self.mapView = mapView
		self.fraction = fraction
	}
}

struct FlightMapView: UIViewRepresentable {
	var startCoordinate: CLLocationCoordinate2D
	var endCoordinate: CLLocationCoordinate2D
	var progress: CGFloat
	
	func makeUIView(context: Context) -> MKMapView {
		let view = MKMapView(frame: .zero)
		view.delegate = context.coordinator
		return view
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		let startOverlay = MKCircle(center: startCoordinate, radius: 10000)
		let endOverlay = MKCircle(center: endCoordinate, radius: 10000)
		let flightPath = MKGeodesicPolyline(coordinates: [startCoordinate, endCoordinate], count: 2)
		uiView.addOverlays([startOverlay, endOverlay, flightPath])
		
		let startPoint = MKMapPoint(startCoordinate)
		let endPoint = MKMapPoint(endCoordinate)
		
		let minXPoint = min(startPoint.x, endPoint.x)
		let minYPoint = min(startPoint.y, endPoint.y)
		let maxXPoint = max(startPoint.x, endPoint.x)
		let maxYPoint = max(startPoint.y, endPoint.y)
		
		let mapRect = MKMapRect(x: minXPoint, y: minYPoint, width: maxXPoint - minXPoint, height: maxYPoint - minYPoint)
		
		let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		
		uiView.setVisibleMapRect(mapRect, edgePadding: padding, animated: true)
		
		uiView.mapType = .mutedStandard
		uiView.isScrollEnabled = false
	}
	
	func makeCoordinator() -> MapCoordinator {
		MapCoordinator(mapView: self, fraction: progress)
	}
}

extension MapCoordinator: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKCircle {
			let renderer = MKCircleRenderer(overlay: overlay)
			renderer.fillColor = .black
			renderer.strokeColor = .black
			return renderer
		}
		if overlay is MKGeodesicPolyline {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.3)
			renderer.lineWidth = 3
			renderer.strokeStart = 0
			renderer.strokeEnd = fraction
			return renderer
		}
		return MKOverlayRenderer()
	}
}

#Preview(body: {
			FlightMapView(
				startCoordinate: CLLocationCoordinate2D(
					latitude: 35.655, longitude: -83.4411
				),
				endCoordinate: CLLocationCoordinate2D(
					latitude: 36.0840, longitude: -115.1537
				),
				progress: 0.67
			)
			.frame(width: 300, height: 300)
})
