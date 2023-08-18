import ComposableArchitecture

struct ParentWithoutFeature: Reducer {
    struct State {
        @PresentationState var destination: Destination.State?
    }

    enum Action {
        case destination(PresentationAction<Destination.Action>)

        case didTap(Button)

        enum Button {
            case first
            case second
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTap(.first):
                state.destination = .firstChild(.init())

            case .didTap(.second):
                state.destination = .secondChild(.init())

            default:
                break
            }

            return .none
        }
        .ifLet(\.$destination, action: /Action.destination) { Destination() }
    }
}

extension ParentWithoutFeature {
    struct Destination: Reducer {
        enum State {
            case firstChild(FirstChildWithoutFeature.State)
            case secondChild(SecondChildWithoutFeature.State)
        }

        enum Action {
            case firstChild(FirstChildWithoutFeature.Action)
            case secondChild(SecondChildWithoutFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: /State.firstChild, action: /Action.firstChild) { FirstChildWithoutFeature() }
            Scope(state: /State.secondChild, action: /Action.secondChild) { SecondChildWithoutFeature() }
        }
    }
}
