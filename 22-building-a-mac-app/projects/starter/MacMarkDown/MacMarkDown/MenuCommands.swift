//
//  MenuCommands.swift
//  MacMarkDown
//
//  Created by Quoc Nguyen on 2024/01/04.
//

import SwiftUI

struct MenuCommands: Commands {
	@AppStorage("styleSheet") var styleSheet: StyleSheet = .github
	
	var body: some Commands {
		CommandGroup(before: .help) {
			Button("Markdown Cheatsheet") {
				showCheatSheet()
			}
		}
		CommandMenu("Stylesheet") {
			ForEach(StyleSheet.allCases, id: \.self) { style in
				Button(style.rawValue) {
					styleSheet = style
				}.keyboardShortcut(style.shortcutKey, modifiers: .command)
			}
		}
	}
	
	func showCheatSheet() {
		let cheatSheetAdress = "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
		guard let url = URL(string: cheatSheetAdress) else { fatalError("Invalid cheatsheet URL") }
		NSWorkspace.shared.open(url)
	}
}
