// System
import Combine
import UIKit

// SDK
import ComposableArchitecture

final class SecondChildWithoutViewController: UIViewController {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let store: StoreOf<SecondChildWithoutFeature>
    private let viewStore: ViewStore<ViewState, ViewAction>

    // MARK: - Init
    init(store: StoreOf<SecondChildWithoutFeature>) {
        self.store = store
        self.viewStore = .init(store, observe: ViewState.init, send: SecondChildWithoutFeature.Action.init)

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

private extension SecondChildWithoutViewController {
    // MARK: - Setup items
    func setupItems() {
        setupUI()
        setupVS()
    }

    func setupUI() {
        view.backgroundColor = .yellow

        setupBackButton()
    }

    func setupVS() {}
}

private extension SecondChildWithoutViewController {
    // MARK: - Setup UI
    func setupBackButton() {
        let backButton = UIButton()
        backButton.frame = .init(x: 100, y: 300, width: 100, height: 100)

        backButton.setTitle("BACK", for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        view.addSubview(backButton)
    }
}

private extension SecondChildWithoutViewController {
    // MARK: - Private methods
    @objc func didTapBackButton() {
        viewStore.send(.didTapBackButton)
    }
}

private extension SecondChildWithoutViewController {
    // MARK: - View feature
    struct ViewState: Equatable {
        init(state: SecondChildWithoutFeature.State) {}
    }

    enum ViewAction {
        case didTapBackButton
    }
}

private extension SecondChildWithoutFeature.Action {
    // MARK: - Action init
    init(action: SecondChildWithoutViewController.ViewAction) {
        switch action {
        case .didTapBackButton:
            self = .didTapBackButton
        }
    }
}
