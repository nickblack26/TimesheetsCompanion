//
//  SignInWithAppleButtonViewRepresentable.swift
//  TimesheetsCompanion
//
//  Created by Nick on 10/5/23.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonViewRepresentable: NSViewRepresentable {
	let type: ASAuthorizationAppleIDButton.ButtonType
	let style: ASAuthorizationAppleIDButton.Style
	
	func makeNSView(context: Context) -> ASAuthorizationAppleIDButton {
		ASAuthorizationAppleIDButton(type: type, style: style)
	}
	
	func updateNSView(_ nsView: NSViewType, context: Context) {
		
	}
}

#Preview {
	SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
		.allowsHitTesting(false)
		.previewLayout(.sizeThatFits)
}
