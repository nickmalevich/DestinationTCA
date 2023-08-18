// System
import Combine
import UIKit

// SDK
import ComposableArchitecture

final class ParentWithoutViewController: UIViewController {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let store: StoreOf<ParentWithoutFeature>
    private let viewStore: ViewStore<ViewState, ViewAction>

    // MARK: - Init
    init(store: StoreOf<ParentWithoutFeature>) {
        self.store = store
        self.viewStore = .init(store, observe: ViewState.init, send: ParentWithoutFeature.Action.init)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
    }
}

private extension ParentWithoutViewController {
    // MARK: - Setup items
    func setupItems() {
        setupUI()
        setupVS()
    }

    func setupUI() {
        view.backgroundColor = .red

        navigationController?.setNavigationBarHidden(true, animated: false)
        setupFirstButton()
        setupSecondButton()
    }

    func setupVS() {
        store.scope(
            state: {
                switch $0.destination {
                case .firstChild(let state):
                    return state

                default:
                    return nil
                }
            },
            action: { .destination(.presented(.firstChild($0))) }
        )
        .ifLet { [weak self] in
            let firstChildWithoutViewController = FirstChildWithoutViewController(store: $0)
            firstChildWithoutViewController.modalPresentationStyle = .fullScreen

            self?.present(firstChildWithoutViewController, animated: true)
        } else: { [weak self] in
            self?.dismiss(animated: true)
        }
        .store(in: &cancellables)

        store.scope(
            state: {
                switch $0.destination {
                case .secondChild(let state):
                    return state

                default:
                    return nil
                }
            },
            action: { .destination(.presented(.secondChild($0))) }
        )
        .ifLet { [weak self] in
            self?.navigationController?.pushViewController(SecondChildWithoutViewController(store: $0), animated: true)
        } else: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        .store(in: &cancellables)
    }
}

private extension ParentWithoutViewController {
    // MARK: - Setup UI
    func setupFirstButton() {
        let firstButton = UIButton()
        firstButton.frame = .init(x: 100, y: 200, width: 100, height: 100)

        firstButton.setTitle("FIRST", for: .normal)
        firstButton.addTarget(self, action: #selector(didTapFirstButton), for: .touchUpInside)
        view.addSubview(firstButton)
    }

    func setupSecondButton() {
        let secondButton = UIButton()
        secondButton.frame = .init(x: 100, y: 400, width: 100, height: 100)

        secondButton.setTitle("SECOND", for: .normal)
        secondButton.addTarget(self, action: #selector(didTapSecondButton), for: .touchUpInside)
        view.addSubview(secondButton)
    }
}

private extension ParentWithoutViewController {
    // MARK: - Private methods
    @objc func didTapFirstButton() {
        viewStore.send(.didTap(.first))
    }

    @objc func didTapSecondButton() {
        viewStore.send(.didTap(.second))
    }
}

private extension ParentWithoutViewController {
    // MARK: - View feature
    struct ViewState: Equatable {
        init(state: ParentWithoutFeature.State) {}
    }

    enum ViewAction {
        case didTap(Button)

        enum Button {
            case first
            case second
        }
    }
}

private extension ParentWithoutFeature.Action {
    // MARK: - Action init
    init(action: ParentWithoutViewController.ViewAction) {
        switch action {
        case .didTap(.first):
            self = .didTap(.first)

        case .didTap(.second):
            self = .didTap(.second)
        }
    }
}
