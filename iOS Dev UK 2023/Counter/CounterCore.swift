import ComposableArchitecture

struct CounterCore: Reducer {
	struct State: Equatable {
		var count: Int
	}

	enum Action: Equatable {
		case view(ViewAction)

		enum ViewAction: Equatable {
			case incrementButtonTapped
			case decrementButtonTapped
			case numberFactButtonTapped
			case favouriteButtonTapped
		}
	}

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
				// TODO: Get number fact
				return .none

			case .view(.favouriteButtonTapped):
				// TODO: Toggle favourite
				return .none
			}
		}
	}
}
