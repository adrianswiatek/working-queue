import UIKit

protocol WorkflowCellDelegate: AnyObject {
    func doneButtonDidTap(_ workflowCell: WorkflowCell)
}

class WorkflowCell: UICollectionViewCell, ColorThemeRefreshable {

    weak var delegate: WorkflowCellDelegate?

    private let workflowNameLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.getTextColor = { UIColor.textColor }
        return label
    }()

    private let currentItemLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.getTextColor = { UIColor.tintColor }
        return label
    }()

    private let pendingLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.text = "Pending:"
        label.font = .systemFont(ofSize: 16)
        label.getTextColor = { UIColor.textColor }
        return label
    }()

    private let pendingNumberLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.font = .systemFont(ofSize: 16)
        label.getTextColor = { UIColor.textColor }
        return label
    }()

    private let bottomView: ThemedView = {
        let view = ThemedView()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMinXMaxYCorner)
        view.getBackgroundColor = { UIColor.backgroundColor }
        return view
    }()

    private let doneButton: ThemedButton = {
        let button = ThemedButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "done"), for: .normal)
        button.layer.cornerRadius = 28
        button.layer.borderWidth = 3
        button.getTintColor = { UIColor.tintColor }
        button.getBackgroundColor = { UIColor.accentColor }
        button.getBorderColor = { UIColor.backgroundColor }
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupStyles()
        setupHandlers()
        refreshColorTheme()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func refreshColorTheme() {
        backgroundColor = .accentColor
        layer.shadowColor = UIColor.shadowColor.cgColor
        refreshSubviewsColors()
    }

    private func setupViews() {
        addSubview(workflowNameLabel)
        NSLayoutConstraint.activate([
            workflowNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            workflowNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        addSubview(currentItemLabel)
        NSLayoutConstraint.activate([
            currentItemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            currentItemLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            currentItemLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 38)
        ])

        bottomView.addSubview(pendingLabel)
        NSLayoutConstraint.activate([
            pendingLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -12),
            pendingLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])

        bottomView.addSubview(pendingNumberLabel)
        NSLayoutConstraint.activate([
            pendingNumberLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 36),
            pendingNumberLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])

        addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            doneButton.centerYAnchor.constraint(equalTo: bottomView.topAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 56),
            doneButton.widthAnchor.constraint(equalTo: doneButton.heightAnchor)
        ])
    }

    private func setupStyles() {
        layer.cornerRadius = 15
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.5
    }

    private func setupHandlers() {
        doneButton.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
    }

    @objc private func doneButtonDidTap() {
        delegate?.doneButtonDidTap(self)
    }

    func update(workflowEntry: WorkflowEntry) {
        workflowNameLabel.text = workflowEntry.name
        currentItemLabel.text = workflowEntry.currenQueueEntryName
        pendingNumberLabel.text = String(workflowEntry.numberOfEntries)

        let currentItemExists = workflowEntry.currentQueueEntry != nil
        doneButton.isHidden = !currentItemExists

        let currentItemFontWeight: UIFont.Weight = currentItemExists ? .bold : .regular
        currentItemLabel.font = .systemFont(ofSize: 18, weight: currentItemFontWeight)
    }
}
