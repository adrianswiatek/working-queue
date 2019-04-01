import UIKit

protocol WorkflowEndCellDelegate: AnyObject {
    func removeAllButton(_ workflowEndCell: WorkflowEndCell)
}

class WorkflowEndCell: UICollectionViewCell, ColorThemeRefreshable {

    weak var delegate: WorkflowEndCellDelegate?

    private let workflowEndLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.text = "Finished items"
        label.getTextColor = { UIColor.textColor }
        return label
    }()

    private let itemsLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.text = "Items:"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16)
        label.getTextColor = { UIColor.textColor }
        return label
    }()

    private let itemsNumberLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.text = "0"
        label.textAlignment = .left
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

    private let removeAllButton: ThemedButton = {
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
        addSubview(workflowEndLabel)
        NSLayoutConstraint.activate([
            workflowEndLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            workflowEndLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 38)
        ])

        addSubview(itemsLabel)
        NSLayoutConstraint.activate([
            itemsLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -12),
            itemsLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])

        addSubview(itemsNumberLabel)
        NSLayoutConstraint.activate([
            itemsNumberLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 36),
            itemsNumberLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])

        addSubview(removeAllButton)
        NSLayoutConstraint.activate([
            removeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            removeAllButton.centerYAnchor.constraint(equalTo: bottomView.topAnchor),
            removeAllButton.heightAnchor.constraint(equalToConstant: 56),
            removeAllButton.widthAnchor.constraint(equalTo: removeAllButton.heightAnchor)
        ])
    }

    private func setupStyles() {
        layer.cornerRadius = 15
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.5
    }

    private func setupHandlers() {
        removeAllButton.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
    }

    @objc private func doneButtonDidTap() {
        delegate?.removeAllButton(self)
    }

    func update(workflowEndEntry: WorkflowEndEntry) {
        itemsNumberLabel.text = String(workflowEndEntry.numberOfEntries)
    }
}
