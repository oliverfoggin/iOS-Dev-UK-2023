import SwiftUI
import ComposableArchitecture

struct FavouritesView: View {
	let store: StoreOf<FavouritesCore>

	var body: some View {
		WithViewStore(store, observe: \.favourites, send: FavouritesCore.Action.view) { viewStore in
			List {
				ForEach(viewStore.state, id: \.self) { favourite in
					Text("\(favourite)")
						.frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
						.contentShape(ContainerRelativeShape())
						.onTapGesture {
							viewStore.send(.favouriteTapped(favourite))
						}
				}
				.onDelete {
					viewStore.send(.onDelete($0))
				}
			}
			.onAppear {
				viewStore.send(.onAppear)
			}
			.navigationTitle("Favourites")
		}
	}
}

struct FavouritesView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			FavouritesView(
				store: .init(initialState: .init()) {
					FavouritesCore()
				} withDependencies: {
					$0.favourites.sortedFavourites = { [1, 2, 3, 4, 5] }
				}
			)
		}
	}
}
