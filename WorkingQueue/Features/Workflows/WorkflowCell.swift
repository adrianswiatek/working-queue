import UIKit

class WorkflowCell: UICollectionViewCell {

    private let workflowNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TO READ"
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let currentItemLabel: UILabel = {
        let label = UILabel()
        label.text = "The here and now habit"
        label.textColor = .textColor
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pendingLabel: UILabel = {
        let label = UILabel()
        label.text = "Pending:"
        label.textColor = .textColor
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pendingNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textColor = .textColor
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMinXMaxYCorner)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupStyles()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(workflowNameLabel)
        addSubview(currentItemLabel)
        addSubview(bottomView)

        bottomView.addSubview(pendingLabel)
        bottomView.addSubview(pendingNumberLabel)

        NSLayoutConstraint.activate([
            workflowNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            workflowNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentItemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            currentItemLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            currentItemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 36),
            pendingLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -24),
            pendingLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            pendingNumberLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 24),
            pendingNumberLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
    }

    private func setupStyles() {
        backgroundColor = .accentColor
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.5
    }
}
