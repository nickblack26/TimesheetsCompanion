//
//  LoginView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 6/2/23.
//

import SwiftUI

struct LoginView: View {
	@EnvironmentObject var manager: TSheetManager
	@State private var clientId: String = ""
	@State private var redirectUri: String = ""
	
    var body: some View {
		Form {
			TextField("Client ID", text: $clientId)
				
			TextField("Redirect URI", text: $redirectUri)
			
//		https://deepspacerobots.com
//			09bcce4f97c4452ff25def1e05cf2e43
			
			Button("Save") {
				Task {
					try await manager.authorizationRequest(client_id: clientId, redirect_uri: redirectUri)
				}
			}
			.disabled(clientId.isEmpty || redirectUri.isEmpty)
		}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
