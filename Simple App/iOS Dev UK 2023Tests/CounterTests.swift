import XCTest
import ComposableArchitecture
@testable import iOS_Dev_UK_2023

@MainActor
final class CounterTests: XCTestCase {
	func testCounterIncrementDecrement() async {
		let store = TestStore(initialState: .init()) {
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
		let testFact = "42 is a number"

		let store = TestStore(initialState: .init(count: 42)) {
			Counter()
		} withDependencies: {
			$0.factClient.overrideGetFact(for: 42) { testFact }
		}

		await store.send(.view(.numberFactButtonTapped))

		await store.receive(.factClientResponse(.success(testFact))) {
			$0.alert = .init(title: TextState(testFact))
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
