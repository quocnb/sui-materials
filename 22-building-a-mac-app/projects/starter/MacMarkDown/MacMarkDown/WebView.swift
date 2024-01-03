//
//  WebView.swift
//  MacMarkDown
//
//  Created by Quoc Nguyen on 2024/01/04.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
	@AppStorage("styleSheet") var styleSheet: StyleSheet = .github
	var html: String
	
	var formattedHtml: String {
		return """
				<html>
				<head>
					 <link href="\(styleSheet).css" rel="stylesheet">
				</head>
				<body>
					 \(html)
				</body>
				</html>
				"""
	}
	
	func makeNSView(context: Context) -> WKWebView {
		WKWebView()
	}
	
	func updateNSView(_ nsView: WKWebView, context: Context) {
		nsView.loadHTMLString(formattedHtml, baseURL: Bundle.main.resourceURL)
	}
}
