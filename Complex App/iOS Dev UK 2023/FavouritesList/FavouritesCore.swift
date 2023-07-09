import Foundation
import ComposableArchitecture

struct FavouritesCore: Reducer {
	struct State: Equatable {
		var favourites: [Int] = []
	}

	enum Action: Equatable {
		case view(ViewAction)
		case delegate(Delegate)

		enum Delegate: Equatable {
			case showFavourite(Int)
		}

		enum ViewAction: Equatable {
			case onAppear
			case favouriteTapped(Int)
			case onDelete(IndexSet)
		}
	}

	@Dependency(\.favourites) var favourites

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .view(.onAppear):
				state.favourites = favourites.sortedFavourites()
				return .none

			case .view(.favouriteTapped(let value)):
				return .send(.delegate(.showFavourite(value)))

			case .view(.onDelete(let indexSet)):
				indexSet.forEach { index in
					favourites.removeFavourite(state.favourites[index])
				}
				return .none

			case .delegate:
				return .none
			}
		}
	}
}
