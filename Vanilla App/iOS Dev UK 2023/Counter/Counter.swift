import ComposableArchitecture

struct Counter: Reducer {
	struct State: Equatable {
		var count: Int

		@PresentationState var alert: AlertState<Action.Alert>?

		init(count: Int = 0) {
			self.count = count
		}
	}

	enum Action: Equatable {
		case view(ViewAction)

		case factClientResponse(TaskResult<String>)
		case alert(PresentationAction<Alert>)

		enum Alert: Equatable {}

		enum ViewAction: Equatable {
			case incrementButtonTapped
			case decrementButtonTapped
			case numberFactButtonTapped
		}
	}

	@Dependency(\.factClient) var factClient

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
					do {
						let fact = try await factClient.getFact(state.count)
						await send(.factClientResponse(.success(fact)))
					} catch {
						await send(.factClientResponse(.failure(error)))
					}
				}

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
