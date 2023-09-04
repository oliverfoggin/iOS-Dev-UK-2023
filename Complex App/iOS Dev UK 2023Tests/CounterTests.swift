import XCTest
import ComposableArchitecture
@testable import iOS_Dev_UK_2023

@MainActor
final class CounterTests: XCTestCase {
	func testOnAppear() async {
		let store = TestStore(initialState: .init(count: 42)) {
			CounterCore()
		} withDependencies: {
			$0.favourites.overrideIsFavourite(42, with: true)
		}

		await store.send(.view(.onAppear)) {
			$0.isFavourite = true
		}
	}

	func testCounterIncrementDecrement() async {
		let store = TestStore(initialState: .init()) {
			CounterCore()
		} withDependencies: {
			$0.favourites.overrideIsFavourite(0, with: false)
			$0.favourites.overrideIsFavourite(1, with: true)
		}

		await store.send(.view(.incrementButtonTapped)) {
			$0.count = 1
			$0.isFavourite = true
		}

		await store.send(.view(.decrementButtonTapped)) {
			$0.count = 0
			$0.isFavourite = false
		}
	}

	func testNumberFactSuccess() async {
		let testFact = "42 is a number"

		let store = TestStore(initialState: .init(count: 42)) {
			CounterCore()
		} withDependencies: {
			$0.factClient.overrideGetFact(for: 42) { testFact }
		}

		await store.send(.view(.numberFactButtonTapped))

		await store.receive(.factClientResponse(.success(testFact))) {
			$0.destination = .alert(.init(title: TextState(testFact)))
		}
	}

	func testNumberFactError() async {
		let store = TestStore(initialState: .init(count: 42)) {
			CounterCore()
		} withDependencies: {
			$0.factClient.overrideGetFact(for: 42) { throw URLError(.badURL) }
		}

		await store.send(.view(.numberFactButtonTapped))

		await store.receive(.factClientResponse(.failure(URLError(.badURL)))) {
			$0.destination = .alert(.init(title: TextState("The operation couldn’t be completed. (NSURLErrorDomain error -1000.)")))
		}
	}

	func testTapFavouriteButton() async {
		let store = TestStore(initialState: .init(count: 42)) {
			CounterCore()
		} withDependencies: {
			$0.favourites.expectAddFavourite(42)
			$0.favourites.overrideIsFavourite(42, with: false)
		}

		await store.send(.view(.favouriteButtonTapped))
	}

	func testTapFavouriteToolbarItem() async {
		let store = TestStore(initialState: .init(count: 42)) {
			CounterCore()
		}

		await store.send(.view(.favouriteToolBarItemTapped)) {
			$0.destination = .favourites(.init())
		}
	}

	func testFavouriteDelegateAction() async {
		let store = TestStore(initialState: .init(count: 42)) {
			CounterCore()
		} withDependencies: {
			$0.favourites.overrideIsFavourite(1729, with: true)
		}

		await store.send(.view(.favouriteToolBarItemTapped)) {
			$0.destination = .favourites(.init())
		}

		await store.send(.destination(.presented(.favourites(.delegate(.showFavourite(1729)))))) {
			$0.count = 1729
			$0.isFavourite = true
			$0.destination = nil
		}
	}
}
