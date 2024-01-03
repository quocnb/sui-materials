//
//  MacMarkDownApp.swift
//  MacMarkDown
//
//  Created by Quoc Nguyen on 2024/01/03.
//

import SwiftUI

@main
struct MacMarkDownApp: App {
	var body: some Scene {
		DocumentGroup(newDocument: MacMarkDownDocument()) { file in
			ContentView(document: file.$document)
		}.commands {
			MenuCommands()
		}
		Settings {
			SettingsView()
		}
	}
}
