import UIKit

protocol DequeuePopupControllerDelegate: AnyObject {
    func didReplace()
    func didProceedInWorkflow()
}

public class DequeuePopupController: UIViewController {

    weak var delegate: DequeuePopupControllerDelegate?

    weak var workflowEntry: WorkflowEntry? {
        didSet {
            if let currentItemName = workflowEntry?.currentQueueEntry?.name {
                itemLabel.text = currentItemName
            }
        }
    }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.accentColor.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Dequeue item"
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .accentColor
        label.textColor = .tintColor
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "You have an item added to process:"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.backgroundColor = .backgroundColor
        label.textColor = .textColor
        label.transform = CGAffineTransform(translationX: 0, y: 6)
        return label
    }()

    private let itemLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .backgroundColor
        label.textColor = .textColor
        label.transform = CGAffineTransform(translationX: 0, y: -6)
        return label
    }()

    private let containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let proceedInWorkflowButton: UIButton =
        DequeuePopupButton(title: "Proceed in workflow", isPrimaryAction: true)

    private let replaceButton: UIButton =
        DequeuePopupButton(title: "Replace")

    private let cancelButton: UIButton =
        DequeuePopupButton(title: "Cancel")

    private let darkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupUserEvents()
    }

    private func setupView() {
        view.backgroundColor = .clear
        setupStackView()
    }

    private func setupStackView() {
        containerStack.addArrangedSubview(headerLabel)
        containerStack.addArrangedSubview(infoLabel)
        containerStack.addArrangedSubview(itemLabel)
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
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -92),
            containerView.heightAnchor.constraint(equalToConstant: 124),
            containerView.widthAnchor.constraint(equalToConstant: view.frame.width / 1.25)
        ])

        containerView.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        view.addSubview(proceedInWorkflowButton)
        NSLayoutConstraint.activate([
            proceedInWorkflowButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            proceedInWorkflowButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 24),
            proceedInWorkflowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            proceedInWorkflowButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        view.addSubview(replaceButton)
        NSLayoutConstraint.activate([
            replaceButton.leadingAnchor.constraint(equalTo: proceedInWorkflowButton.leadingAnchor),
            replaceButton.topAnchor.constraint(equalTo: proceedInWorkflowButton.bottomAnchor, constant: 8),
            replaceButton.trailingAnchor.constraint(equalTo: proceedInWorkflowButton.trailingAnchor),
            replaceButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: replaceButton.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: replaceButton.bottomAnchor, constant: 8),
            cancelButton.trailingAnchor.constraint(equalTo: replaceButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupUserEvents() {
        proceedInWorkflowButton.addTarget(self, action: #selector(handleProceedInWorkflow), for: .touchUpInside)
        replaceButton.addTarget(self, action: #selector(handleReplace), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }

    @objc private func handleProceedInWorkflow() {
        delegate?.didProceedInWorkflow()
        dismiss(animated: true)
    }

    @objc private func handleReplace() {
        delegate?.didReplace()
        dismiss(animated: true)
    }

    @objc private func handleCancel() {
        dismiss(animated: true)
    }
}
