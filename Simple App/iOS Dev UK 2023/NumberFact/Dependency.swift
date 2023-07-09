import ComposableArchitecture

extension DependencyValues {
	var factClient: NumberFactClient {
		get { self[NumberFactClient.self] }
		set { self[NumberFactClient.self] = newValue }
	}
}

extension NumberFactClient: DependencyKey {
	static var liveValue: NumberFactClient = .live
	static var testValue: NumberFactClient = .unimplemented
}
