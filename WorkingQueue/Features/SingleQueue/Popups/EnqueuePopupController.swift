import UIKit

protocol EnqueuePopupControllerDelegate: AnyObject {
    func didAcceptWithText(_ text: String)
}

class EnqueuePopupController: UIViewController {

    weak var delegate: EnqueuePopupControllerDelegate?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Enqueue item"
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .accentColor
        label.textColor = .tintColor
        return label
    }()

    private let nameContainerView = UIView()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.backgroundColor = .backgroundColor
        textField.tintColor = .tintColor
        textField.textColor = .textColor
        textField.returnKeyType = .done
        textField.keyboardAppearance = .dark
        textField.becomeFirstResponder()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .accentColor
        button.tintColor = .tintColor
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .accentColor
        button.tintColor = .tintColor
        return button
    }()

    private let buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let darkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var centerYConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupKeyboardEvents()
    }

    private func setupView() {
        view.backgroundColor = .clear
        setupButtonsStack()
        setupContainerStack()
    }

    private func setupButtonsStack() {
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(okButton)

        okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }

    private func setupContainerStack() {
        containerStack.addArrangedSubview(headerLabel)
        containerStack.addArrangedSubview(nameContainerView)
        containerStack.addArrangedSubview(buttonsStack)
    }

    private func setupConstraints() {
        view.addSubview(darkView)
        NSLayoutConstraint.activate([
            darkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            darkView.topAnchor.constraint(equalTo: view.topAnchor),
            darkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            darkView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 175),
            containerView.widthAnchor.constraint(equalToConstant: view.frame.width / 1.25)
        ])

        centerYConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint.isActive = true

        containerView.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        nameContainerView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -16),
            nameTextField.centerYAnchor.constraint(equalTo: nameContainerView.centerYAnchor),
        ])
    }

    private func setupKeyboardEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillToggle),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillToggle),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc private func keyboardWillToggle(notification: NSNotification) {
        let keyboardRect = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect
        guard let keyboardHeight = keyboardRect?.height else { return }
        let previousMiddle = view.frame.height / 2
        let newHeight = view.frame.height - keyboardHeight
        let newMiddle = newHeight / 2
        setCenterYConstant(to: newMiddle - previousMiddle)
    }

    private func setCenterYConstant(to constant: CGFloat) {
        DispatchQueue.main.async {
            self.centerYConstraint.constant = constant
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: .curveEaseOut,
                animations: { self.view.layoutIfNeeded() })
        }
    }

    @objc func handleOk() {
        if let text = nameTextField.text {
            delegate?.didAcceptWithText(text)
            dismiss(animated: true)
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true)
    }
}

extension EnqueuePopupController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleOk()
        return true
    }
}
