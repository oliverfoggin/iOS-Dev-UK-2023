import SwiftUI
import ComposableArchitecture

struct CounterView: View {
	let store: StoreOf<Counter>

	var body: some View {
		NavigationStack {
			WithViewStore(
				store,
				observe: \.count,
				send: Counter.Action.view
			) { viewStore in
				VStack {
					Text("\(viewStore.state)")
						.font(.largeTitle)

					HStack {
						Button {
							viewStore.send(.decrementButtonTapped)
						} label: {
							Image(systemName: "minus")
								.frame(width: 38, height: 28)
						}

						Button {
							viewStore.send(.incrementButtonTapped)
						} label: {
							Image(systemName: "plus")
								.frame(width: 38, height: 28)
						}
					}
					.buttonStyle(.bordered)

					Button {
						viewStore.send(.numberFactButtonTapped)
					} label: {
						Text("Get number fact")
					}
					.buttonStyle(.borderedProminent)
				}
			}
			.navigationTitle("Counter")
			.alert(store: store.scope(state: \.$alert, action: Counter.Action.alert))
		}
	}
}

struct CounterView_Previews: PreviewProvider {
	static var previews: some View {
		CounterView(
			store: .init(initialState: .init(count: 17)) {
				Counter()
			} withDependencies: {
				$0.factClient.getFact = { value in
					"\(value) is a good number!"
				}
			}
		)
	}
}
