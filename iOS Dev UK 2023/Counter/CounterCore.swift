import ComposableArchitecture

struct CounterCore: Reducer {
	struct State: Equatable {
		var count: Int

		@PresentationState var alert: AlertState<Action.Alert>?

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
		case alert(PresentationAction<Alert>)

		case factClientResponse(TaskResult<String>)

		enum Alert: Equatable {}

		enum ViewAction: Equatable {
			case incrementButtonTapped
			case decrementButtonTapped
			case numberFactButtonTapped
			case favouriteButtonTapped
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

			case .factClientResponse(.success(let fact)):
				state.alert = AlertState { TextState(fact) }
				return .none

			case .factClientResponse(.failure(let error)):
				state.alert = AlertState { TextState(error.localizedDescription) }
				return .none

			case .alert:
				return .none
			}
		}
		.ifLet(\.$alert, action: /Action.alert)
	}
}
