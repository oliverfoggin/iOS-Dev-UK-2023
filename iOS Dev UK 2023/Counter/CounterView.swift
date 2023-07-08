import SwiftUI
import ComposableArchitecture

struct CounterView: View {
	struct ViewState: Equatable {
		let count: Int

		init(state: CounterCore.State) {
			count = state.count
		}
	}

	let store: StoreOf<CounterCore>

	var body: some View {
		NavigationStack {
			WithViewStore(
				store.scope(state: { $0 }, action: CounterCore.Action.view),
				observe: ViewState.init
			) { viewStore in
				VStack {
					Text("\(viewStore.count)")
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
		}
	}
}

struct CounterView_Previews: PreviewProvider {
	static var previews: some View {
		CounterView(
			store: .init(
				initialState: .init(count: 0),
				reducer: CounterCore()
			)
		)
	}
}
