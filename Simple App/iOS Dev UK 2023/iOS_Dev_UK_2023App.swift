import SwiftUI
import ComposableArchitecture

@main
struct iOS_Dev_UK_2023App: App {
	var body: some Scene {
		WindowGroup {
			CounterView(
				store: .init(
					initialState: .init(count: 0),
					reducer: CounterCore()
						._printChanges(.actionLabels)
				)
			)
		}
	}
}
