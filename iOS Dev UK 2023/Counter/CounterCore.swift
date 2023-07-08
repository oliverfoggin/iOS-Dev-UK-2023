import ComposableArchitecture

struct CounterCore: Reducer {
	struct State: Equatable {
		enum Destination: Equatable {
			case alert(AlertState<Action.Alert>)
			case favourites(FavouritesCore.State)
		}

		var count: Int

		@PresentationState var destination: Destination?

		var isFavrouite: Bool {
			@Dependency(\.favourites) var favourites

			return favourites.isFavourite(count)
		}

		init(count: Int = 0) {
			self.count = count
		}
	}

	enum Action: Equatable {
		case view(ViewAction)
		case destination(PresentationAction<Destination>)

		case factClientResponse(TaskResult<String>)

		enum Destination: Equatable {
			case alert(Alert)
			case favourites(FavouritesCore.Action)
		}

		enum Alert: Equatable {}

		enum ViewAction: Equatable {
			case incrementButtonTapped
			case decrementButtonTapped
			case numberFactButtonTapped
			case favouriteButtonTapped
			case favouriteToolBarItemTapped
		}
	}

	@Dependency(\.factClient) var factClient
	@Dependency(\.favourites) var favourites

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .view(.incrementButtonTapped):
				state.count += 1
				return .none

			case .view(.decrementButtonTapped):
				state.count -= 1
				return .none

			case .view(.numberFactButtonTapped):
				return .run { [state] send in
					await send(.factClientResponse(
						TaskResult {
							try await factClient.getFact(state.count)
						}
					))
				}

			case .view(.favouriteButtonTapped):
				if favourites.isFavourite(state.count) {
					favourites.removeFavourite(state.count)
				} else {
					favourites.addFavourite(state.count)
				}
				return .none

			case .view(.favouriteToolBarItemTapped):
				state.destination = .favourites(.init())
				return .none

			case .factClientResponse(.success(let fact)):
				state.destination = .alert(AlertState { TextState(fact) })
				return .none

			case .factClientResponse(.failure(let error)):
				state.destination = .alert(AlertState { TextState(error.localizedDescription) })
				return .none

			case .destination(.presented(.favourites(.delegate(.showFavourite(let favourite))))):
				state.count = favourite
				state.destination = nil
				return .none

			case .destination:
				return .none
			}
		}
		.ifLet(\.$destination, action: /Action.destination) {
			Scope(state: /State.Destination.alert, action: /Action.Destination.alert) {
				EmptyReducer()
			}
			Scope(state: /State.Destination.favourites, action: /Action.Destination.favourites) {
				FavouritesCore()
			}
		}
	}
}
