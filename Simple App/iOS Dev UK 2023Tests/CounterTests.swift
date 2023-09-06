import XCTest
import ComposableArchitecture
@testable import iOS_Dev_UK_2023

@MainActor
final class CounterTests: XCTestCase {
	func testCounterIncrementDecrement() async {
		let store = TestStore(initialState: Counter.State()) {
			Counter()
		}

		await store.send(.view(.incrementButtonTapped)) {
			$0.count = 1
		}

		await store.send(.view(.decrementButtonTapped)) {
			$0.count = 0
		}
	}

	func testNumberFactSuccess() async {
		let store = TestStore(initialState: Counter.State(count: 42)) {
			Counter()
		} withDependencies: { dependencies in
			dependencies.factClient.getFact = { int in "\(int) is a number" }
		}

		await store.send(.view(.numberFactButtonTapped))

		await store.receive(.factClientResponse(.success("42 is a number"))) { state in
			state.alert = .init(title: TextState("42 is a number"))
		}
	}

	func testNumberFactError() async {
		let store = TestStore(initialState: .init(count: 42)) {
			Counter()
		} withDependencies: {
			$0.factClient.overrideGetFact(for: 42) { throw URLError(.badURL) }
		}

		await store.send(.view(.numberFactButtonTapped))

		await store.receive(.factClientResponse(.failure(URLError(.badURL)))) {
			$0.alert = .init(title: TextState("The operation couldn’t be completed. (NSURLErrorDomain error -1000.)"))
		}
	}
}
