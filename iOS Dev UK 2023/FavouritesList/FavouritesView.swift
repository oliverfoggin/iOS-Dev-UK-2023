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
