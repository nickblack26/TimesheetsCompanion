//
//  LoginView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 6/2/23.
//

import SwiftUI
import AuthenticationServices
@_spi(Experimental) import GoTrue

struct LoginView: View {
	@Environment(\.dismissWindow) private var dismissWindow
	@Environment(SupabaseManager.self) private var supabase
	
	@State private var email: String = "nicholas.black98@icloud.com"
	@State private var password: String = "Bl@ck98!"
	
    var body: some View {
		VStack(alignment: .leading, content: {
			SignInWithAppleButton { request in
				request.requestedScopes = [.email, .fullName]
			} onCompletion: { result in
				Task {
					do {
						guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
						else {
							return
						}
						
						guard let idToken = credential.identityToken
							.flatMap({ String(data: $0, encoding: .utf8) })
						else {
							return
						}
						try await supabase.client.auth.signInWithIdToken(
							credentials: .init(
								provider: .apple,
								idToken: idToken
							)
						)
					} catch {
						dump(error)
					}
				}
			}
			.fixedSize()
			
			HStack {
				VStack {
					Divider()
				}
				
				Text("Or")
				
				VStack {
					Divider()
				}
			}
			
			Form {
				TextField("Email", text: $email)
					.labelsHidden()
				
				TextField("Password", text: $password)
					.labelsHidden()
				
				Button("Save") {
					supabase.signIn(email: email, password: password)
					dismissWindow(id: "loginView")
				}
				.disabled(email.isEmpty || password.isEmpty)
			}
			.formStyle(.grouped)
		})
		
		
    }
}

let previewSupabaseManager = SupabaseManager()

#Preview {
	LoginView()
		.environment(previewSupabaseManager)
}
