import SwiftUI
import ComposableArchitecture

struct CounterView: View {
	struct ViewState: Equatable {
		let count: Int
		let isFavourite: Bool

		init(state: CounterCore.State) {
			count = state.count
			isFavourite = state.isFavrouite
		}
	}

	let store: StoreOf<CounterCore>

	var body: some View {
		NavigationStack {
			WithViewStore(
				store,
				observe: ViewState.init,
				send: CounterCore.Action.view
			) { viewStore in
				VStack {
					Button {
						viewStore.send(.favouriteButtonTapped)
					} label: {
						Label {
							Text("\(viewStore.count)")
						} icon: {
							Image(systemName: viewStore.isFavourite ? "star.fill" : "star")
								.resizable()
								.scaledToFit()
								.frame(width: 38, height: 38)
								.foregroundColor(viewStore.isFavourite ? .yellow : .gray)
						}
					}
					.font(.largeTitle)
					.buttonStyle(.plain)

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
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							viewStore.send(.favouriteToolBarItemTapped)
						} label: {
							Text("Favourites")
						}
					}
				}
			}
			.alert(
				store: store.scope(state: \.$destination, action: CounterCore.Action.destination),
				state: /CounterCore.State.Destination.alert,
				action: CounterCore.Action.Destination.alert
			)
			.navigationDestination(
				store: store.scope(state: \.$destination, action: CounterCore.Action.destination),
				state: /CounterCore.State.Destination.favourites,
				action: CounterCore.Action.Destination.favourites,
				destination: FavouritesView.init
			)
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
