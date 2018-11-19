import UIKit

class EnqueuePopupController: UIViewController {

    var callback: (String) -> Void

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(callback: @escaping (String) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupButtons()
        setupConstraints()
    }

    private func setupView() {
        view.backgroundColor = .clear
    }

    private func setupButtons() {
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }

    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            containerView.widthAnchor.constraint(equalToConstant: view.frame.width / 1.5),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func handleCancel() {
        dismiss(animated: true)
    }
}
