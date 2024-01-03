//
//  ToolbarCommands.swift
//  MacMarkDown
//
//  Created by Quoc Nguyen on 2024/01/04.
//

import SwiftUI

enum PreviewState {
	case hidden
	case html
	case web
}

struct PreviewToolbarItem: ToolbarContent {
	@Binding var previewState: PreviewState
	
	var body: some ToolbarContent {
		ToolbarItem {
			Picker("", selection: $previewState) {
				Image(systemName: "eye.slash")
					.tag(PreviewState.hidden)
				Image(systemName: "doc.plaintext")
					.tag(PreviewState.html)
				Image(systemName: "doc.richtext")
					.tag(PreviewState.web)
			}.pickerStyle(.segmented)
				.help("Hide preview, show HTML or web view")
		}
	}
}
