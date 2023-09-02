import SwiftUI

struct CounterView: View {
	@State var count: Int = 0
	@State var fact: String?
	@State var showFact: Bool = false

	var body: some View {
		NavigationStack {
			VStack {
				Text("\(count)")
					.font(.largeTitle)

				HStack {
					Button {
						count -= 1
					} label: {
						Image(systemName: "minus")
							.frame(width: 38, height: 28)
					}

					Button {
						count += 1
					} label: {
						Image(systemName: "plus")
							.frame(width: 38, height: 28)
					}
				}
				.buttonStyle(.bordered)

				Button {
					Task { await self.getFact() }
				} label: {
					Text("Get number fact")
				}
				.buttonStyle(.borderedProminent)
			}
			.navigationTitle("Counter")
			.alert(
				"Number Fact",
				isPresented: $showFact,
				actions: {}
			) {
				if let fact {
					Text(fact)
				}
			}
		}
	}

	func getFact() async {
		do {
			let url = URL(string: "http://numbersapi.com/\(count)")!

			let result = try await URLSession.shared.data(from: url)

			self.fact = String(data: result.0, encoding: .utf8)!
			self.showFact = true
		} catch {
			self.fact = error.localizedDescription
			self.showFact = true
		}
	}
}

struct CounterView_Previews: PreviewProvider {
	static var previews: some View {
		CounterView(
//			store: .init(
//				initialState: .init(count: 0),
//				reducer: Counter()
//			)
		)
	}
}
