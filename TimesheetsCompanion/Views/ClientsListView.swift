//
//  ClientsListView.swift
//  TimesheetsCompanion
//
//  Created by Nick on 5/22/23.
//

import SwiftUI

struct ClientsListView: View {
	// MARK: Environment Variables
	@Environment(SupabaseManager.self) private var supabase
	@Environment(AppNavigation.self) private var navigation
	
	// MARK: State Variables
	@State private var clients: [ClientModel] = []
	@State private var searchBar: String = ""
	
	var tabDestination: Tab?
	
	var body: some View {
		Grid(alignment: .topLeading, verticalSpacing: 7.5) {
			Button {
				navigation.navigate(tab: .home)
			} label: {
				Text("Clients")
					.frame(maxWidth: .infinity, alignment: .leading)
					.fontWeight(.bold)
			}
			.buttonStyle(.plain)
			.padding(.horizontal, 10)
			
			Divider()
			
			GridRow(alignment: .top) {
				VStack(alignment: .leading, spacing: 5) {
					if(clients.isEmpty) {
						ProgressView()
							.frame(maxWidth: .infinity, alignment: .center)
					} else {
						ForEach(clients) { client in
							Button {
								//								if clientSelection != nil {
								//									clientSelection = client
								//								} else {
								//								}
								supabase.currentClient = client
							} label: {
								ClientListItem(client: client, currentClient: supabase.currentClient)
							}
							.frame(maxWidth: .infinity)
							.buttonStyle(.plain)
						}
					}
				}
			}
			.searchable(text: $searchBar)
		}
		.padding(.vertical, 10)
		.padding(.horizontal, 5)
		.task {
			let query = supabase.client.database
				.from("clients")
				.select()
				.limit(count: 10)
			
			do {
				clients = try await query.execute().value
			} catch {
				clients = []
				print("### Select Error: \(error)")
			}
		}
	}
}

#Preview {
	ClientsListView()
		.environment(previewSupabaseManager)
		.environment(previewNavigationManager)
}
