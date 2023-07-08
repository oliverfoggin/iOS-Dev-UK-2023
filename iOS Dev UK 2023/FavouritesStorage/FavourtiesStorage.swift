import ComposableArchitecture

struct Favourites {
	var addFavourite: (Int) -> Void
	var removeFavourite: (Int) -> Void
	var isFavourite: (Int) -> Bool
	var sortedFavourites: () -> [Int]
}

extension DependencyValues {
	var favourites: Favourites {
		get { self[Favourites.self] }
		set { self[Favourites.self] = newValue }
	}
}

extension Favourites: DependencyKey {
	static var liveValue: Favourites = .live
	static var testValue: Favourites = .unimplemented
}

extension Favourites {
	static var unimplemented: Self {
		.init(
			addFavourite: XCTUnimplemented("\(self.self).addFavourite"),
			removeFavourite: XCTUnimplemented("\(self.self).removeFavourite"),
			isFavourite: XCTUnimplemented("\(self.self).isFavourite"),
			sortedFavourites: XCTUnimplemented("\(self.self).sortedFavourites")
		)
	}
}

class FavouritesStorage {
	private var favourites: Set<Int> = []

	func add(favourite: Int) {
		favourites.insert(favourite)
	}

	func remove(favourite: Int) {
		favourites.remove(favourite)
	}

	func isFavourite(value: Int) -> Bool {
		favourites.contains(value)
	}

	func sortedFavourites() -> [Int] {
		favourites.sorted(by: <)
	}
}

extension Favourites {
	static var live: Self {
		let storage = FavouritesStorage()

		return .init(
			addFavourite: storage.add,
			removeFavourite: storage.remove,
			isFavourite: storage.isFavourite,
			sortedFavourites: storage.sortedFavourites
		)
	}
}
