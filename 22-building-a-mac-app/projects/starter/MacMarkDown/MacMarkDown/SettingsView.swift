//
//  SettingsView.swift
//  MacMarkDown
//
//  Created by Quoc Nguyen on 2024/01/04.
//

import SwiftUI

struct SettingsView: View {
	// Settings: Font size
	@AppStorage("editorFontSize") var editorFontSize: Int = 14
	
	var body: some View {
		Stepper("Font size: \(editorFontSize)", value: $editorFontSize, in: 10...30)
			.frame(width: 260, height: 80)
	}
}

#Preview {
	SettingsView()
}
