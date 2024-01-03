//
//  ContentView.swift
//  MacMarkDown
//
//  Created by Quoc Nguyen on 2024/01/03.
//

import SwiftUI

struct ContentView: View {
	@Binding var document: MacMarkDownDocument
	@AppStorage("editorFontSize") var editorFontSize: Int = 14
	@State private var previewState = PreviewState.web

	var attributedString: AttributedString {
		let markdownOptions = AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnly)
		let attribString = try? AttributedString(markdown: document.text, options: markdownOptions)
		return attribString ?? AttributedString("There was an error parsing the Markdown.")
	}
	
	var body: some View {
		HSplitView {
			TextEditor(text: $document.text)
				.font(.system(size: CGFloat(editorFontSize)))
				.frame(minWidth: 200)
			
			if previewState == .web {
				WebView(html: document.html)
					.frame(minWidth: 200)
			} else if previewState == .html {
				ScrollView {
					Text(attributedString)
						.frame(minWidth: 200)
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
						.padding()
						.font(.system(size: CGFloat(editorFontSize)))
						.textSelection(.enabled)
				}
			}
		}.frame(minWidth: 400, minHeight: 300)
			.toolbar(content: {
				PreviewToolbarItem(previewState: $previewState)
			})
	}
}

#Preview {
	ContentView(document: .constant(MacMarkDownDocument()))
}
