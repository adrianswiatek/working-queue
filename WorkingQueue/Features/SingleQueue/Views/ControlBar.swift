import UIKit

class ControlBar: UIView {

    var delegate: ControlBarDelegate?

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dequeueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dequeue"), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(handleDequeue), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = .accentColor
        translatesAutoresizingMaskIntoConstraints = false

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func enableDequeueButton() {
        dequeueButton.isEnabled = true
    }

    func disableDequeueButton() {
        dequeueButton.isEnabled = false
    }

    private func setupViews() {
        let stackView = getStackView()
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func getStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [dequeueButton, addButton])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    @objc private func handleAdd(button: UIButton) {
        delegate?.controlBarDidAdd(self)
    }

    @objc private func handleDequeue(button: UIButton) {
        delegate?.controlBarDidDequeue(self)
    }
}
