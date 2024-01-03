//
//  MacMarkDownDocument.swift
//  MacMarkDown
//
//  Created by Quoc Nguyen on 2024/01/03.
//

import SwiftUI
import UniformTypeIdentifiers
import MarkdownKit

extension UTType {
	static var markdown: UTType {
		UTType(importedAs: "net.daringfireball.markdown")
	}
}

struct MacMarkDownDocument: FileDocument {
	var text: String
	
	var html: String {
		let markdown = MarkdownParser.standard.parse(text)
		return HtmlGenerator.standard.generate(doc: markdown)
	}
	
	init(text: String = "# Hello, MacMarkDown!") {
		self.text = text
	}
	
	static var readableContentTypes: [UTType] { [.markdown] }
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
					let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		text = string
	}
	
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = text.data(using: .utf8)!
		return .init(regularFileWithContents: data)
	}
}
