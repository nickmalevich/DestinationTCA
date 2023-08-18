// System
import Combine
import UIKit

// SDK
import ComposableArchitecture

final class FirstChildWithViewController: UIViewController {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let store: StoreOf<FirstChildWithFeature>
    private let viewStore: ViewStore<ViewState, ViewAction>

    // MARK: - Init
    init(store: StoreOf<FirstChildWithFeature>) {
        self.store = store
        self.viewStore = .init(store, observe: ViewState.init, send: FirstChildWithFeature.Action.init)

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

private extension FirstChildWithViewController {
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

private extension FirstChildWithViewController {
    // MARK: - Setup UI
    func setupBackButton() {
        let backButton = UIButton()
        backButton.frame = .init(x: 100, y: 300, width: 100, height: 100)

        backButton.setTitle("BACK", for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        view.addSubview(backButton)
    }
}

private extension FirstChildWithViewController {
    // MARK: - Private methods
    @objc func didTapBackButton() {
        viewStore.send(.didTapBackButton)
    }
}

private extension FirstChildWithViewController {
    // MARK: - View feature
    struct ViewState: Equatable {
        init(state: FirstChildWithFeature.State) {}
    }

    enum ViewAction {
        case didTapBackButton
    }
}

private extension FirstChildWithFeature.Action {
    // MARK: - Action init
    init(action: FirstChildWithViewController.ViewAction) {
        switch action {
        case .didTapBackButton:
            self = .didTapBackButton
        }
    }
}
