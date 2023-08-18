import ComposableArchitecture

struct SecondChildWithFeature: Reducer {
    struct State {}

    enum Action {
        case didTapBackButton
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .didTapBackButton:
                return .run { _ in await dismiss() }
            }
        }
    }
}
