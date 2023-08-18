// System
import Combine
import UIKit

// SDK
import ComposableArchitecture

final class SecondChildWithViewController: UIViewController {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let store: StoreOf<SecondChildWithFeature>
    private let viewStore: ViewStore<ViewState, ViewAction>

    // MARK: - Init
    init(store: StoreOf<SecondChildWithFeature>) {
        self.store = store
        self.viewStore = .init(store, observe: ViewState.init, send: SecondChildWithFeature.Action.init)

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

private extension SecondChildWithViewController {
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

private extension SecondChildWithViewController {
    // MARK: - Setup UI
    func setupBackButton() {
        let backButton = UIButton()
        backButton.frame = .init(x: 100, y: 300, width: 100, height: 100)

        backButton.setTitle("BACK", for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        view.addSubview(backButton)
    }
}

private extension SecondChildWithViewController {
    // MARK: - Private methods
    @objc func didTapBackButton() {
        viewStore.send(.didTapBackButton)
    }
}

private extension SecondChildWithViewController {
    // MARK: - View feature
    struct ViewState: Equatable {
        init(state: SecondChildWithFeature.State) {}
    }

    enum ViewAction {
        case didTapBackButton
    }
}

private extension SecondChildWithFeature.Action {
    // MARK: - Action init
    init(action: SecondChildWithViewController.ViewAction) {
        switch action {
        case .didTapBackButton:
            self = .didTapBackButton
        }
    }
}
