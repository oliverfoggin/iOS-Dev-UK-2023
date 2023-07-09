import Foundation

extension NumberFactClient {
	static var live: Self {
		.init(
			getFact: { int in
				let url = URL(string: "http://numbersapi.com/\(int)")!

				let result = try await URLSession.shared.data(from: url)

				return String(data: result.0, encoding: .utf8)!
			}
		)
	}
}
