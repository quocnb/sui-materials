/// Copyright (c) 2023 Kodeco Inc.
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

struct RegisterView: View {

	@FocusState var nameFieldFocus: Bool
	@EnvironmentObject var userManager: UserManager

    var body: some View {
			VStack {
				Spacer()
				WelcomeMessageView()
				TextField("Type your name", text: $userManager.profile.name)
					.focused($nameFieldFocus)
					.submitLabel(.done)
					.bordered()
					.onAppear(perform: {
						nameFieldFocus = true
					})
				HStack {
					Spacer()
					Text("\(userManager.profile.name.count)")
						.font(.caption)
						.foregroundStyle(userManager.isUserNameValid() ? Color.green : Color.red)
						.padding(.trailing)
				}
				.padding(.bottom)
				
				HStack {
					Spacer()
					Toggle(isOn: $userManager.settings.rememberUser, label: {
						Text("Remember me")
							.font(.subheadline)
							.foregroundStyle(.gray)
					})
					.fixedSize()
				}
				
				Button(action: {
					registerUser()
				}, label: {
					HStack {
						Image(systemName: "checkmark")
							.resizable()
							.frame(width: 16, height: 16, alignment: .center)
						Text("OK")
							.font(.body)
							.bold()
					}
				})
				.disabled(!userManager.isUserNameValid())
				.bordered()
				Spacer()
			}
			.padding()
			.background(WelcomeBackgroundImage())
    }
}

// MARK: - Event Handlers
extension RegisterView {
	func registerUser() {
		nameFieldFocus = false
		if userManager.settings.rememberUser {
			userManager.persistProfile()
		} else {
			userManager.clear()
		}
		userManager.persistSettings()
		userManager.setRegistered()
	}
}

#Preview {
	RegisterView()
		.environmentObject(UserManager(name: "Quoc"))
}
