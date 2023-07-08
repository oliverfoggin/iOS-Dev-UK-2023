import XCTest
import ComposableArchitecture
@testable import iOS_Dev_UK_2023

@MainActor
final class FavouritesTests: XCTestCase {
	func testOnAppear() async {
		let store = TestStore(
			initialState: .init(),
			reducer: FavouritesCore()
		) {
			$0.favourites.overrideSortedFavourites(with: [1, 2, 3])
		}

		await store.send(.view(.onAppear)) {
			$0.favourites = [1, 2, 3]
		}
	}

	func testTapOnFavourite() async {
		let store = TestStore(
			initialState: .init(),
			reducer: FavouritesCore()
		)

		await store.send(.view(.favouriteTapped(3)))

		await store.receive(.delegate(.showFavourite(3)))
	}
}
