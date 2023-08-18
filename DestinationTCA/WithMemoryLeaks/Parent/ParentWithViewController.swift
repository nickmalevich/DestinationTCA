// System
import Combine
import UIKit

// SDK
import ComposableArchitecture

final class ParentWithViewController: UIViewController {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let store: StoreOf<ParentWithFeature>
    private let viewStore: ViewStore<ViewState, ViewAction>

    // MARK: - Init
    init(store: StoreOf<ParentWithFeature>) {
        self.store = store
        self.viewStore = .init(store, observe: ViewState.init, send: ParentWithFeature.Action.init)

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

private extension ParentWithViewController {
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
        store.scope(state: \.destination, action: { .destination(.presented($0)) })
            .ifLet { [weak self] destinationStore in
                guard let self else {
                    return
                }

                destinationStore.scope(
                    state: /ParentWithFeature.Destination.State.firstChild, action: ParentWithFeature.Destination.Action.firstChild
                )
                .ifLet { [weak self] in
                    let firstChildWithViewController = FirstChildWithViewController(store: $0)
                    firstChildWithViewController.modalPresentationStyle = .fullScreen

                    self?.present(firstChildWithViewController, animated: true)
                }
                .store(in: &cancellables)

                destinationStore.scope(
                    state: /ParentWithFeature.Destination.State.secondChild, action: ParentWithFeature.Destination.Action.secondChild
                )
                .ifLet { [weak self] in
                    self?.navigationController?.pushViewController(SecondChildWithViewController(store: $0), animated: true)
                }
                .store(in: &cancellables)
            } else: { [weak self] in
                guard let self else {
                    return
                }

                dismiss(animated: true)
                navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}

private extension ParentWithViewController {
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

private extension ParentWithViewController {
    // MARK: - Private methods
    @objc func didTapFirstButton() {
        viewStore.send(.didTap(.first))
    }

    @objc func didTapSecondButton() {
        viewStore.send(.didTap(.second))
    }
}

private extension ParentWithViewController {
    // MARK: - View feature
    struct ViewState: Equatable {
        init(state: ParentWithFeature.State) {}
    }

    enum ViewAction {
        case didTap(Button)

        enum Button {
            case first
            case second
        }
    }
}

private extension ParentWithFeature.Action {
    // MARK: - Action init
    init(action: ParentWithViewController.ViewAction) {
        switch action {
        case .didTap(.first):
            self = .didTap(.first)

        case .didTap(.second):
            self = .didTap(.second)
        }
    }
}
