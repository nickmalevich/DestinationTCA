// System
import Combine
import UIKit

// SDK
import ComposableArchitecture

final class FirstChildWithoutViewController: UIViewController {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let store: StoreOf<FirstChildWithoutFeature>
    private let viewStore: ViewStore<ViewState, ViewAction>

    // MARK: - Init
    init(store: StoreOf<FirstChildWithoutFeature>) {
        self.store = store
        self.viewStore = .init(store, observe: ViewState.init, send: FirstChildWithoutFeature.Action.init)

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

private extension FirstChildWithoutViewController {
    // MARK: - Setup items
    func setupItems() {
        setupUI()
        setupVS()
    }

    func setupUI() {
        view.backgroundColor = .green

        setupBackButton()
    }

    func setupVS() {}
}

private extension FirstChildWithoutViewController {
    // MARK: - Setup UI
    func setupBackButton() {
        let backButton = UIButton()
        backButton.frame = .init(x: 100, y: 300, width: 100, height: 100)

        backButton.setTitle("BACK", for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        view.addSubview(backButton)
    }
}

private extension FirstChildWithoutViewController {
    // MARK: - Private methods
    @objc func didTapBackButton() {
        viewStore.send(.didTapBackButton)
    }
}

private extension FirstChildWithoutViewController {
    // MARK: - View feature
    struct ViewState: Equatable {
        init(state: FirstChildWithoutFeature.State) {}
    }

    enum ViewAction {
        case didTapBackButton
    }
}

private extension FirstChildWithoutFeature.Action {
    // MARK: - Action init
    init(action: FirstChildWithoutViewController.ViewAction) {
        switch action {
        case .didTapBackButton:
            self = .didTapBackButton
        }
    }
}
