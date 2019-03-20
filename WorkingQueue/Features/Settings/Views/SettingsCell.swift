import UIKit

public class SettingsCell: UITableViewCell, ColorThemeRefreshable {

    public var cellDidTap: (() -> Void)?

    public var viewModel: String? {
        didSet {
            label.text = viewModel
        }
    }

    private let label: ThemedLabel = {
        let label = ThemedLabel()
        label.font = .systemFont(ofSize: 15)
        label.getTextColor = { UIColor.tintColor }
        return label
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupGestureRecognizer()
        refreshColorTheme()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupViews() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            cellDidTap?()
        }
    }

    public func refreshColorTheme() {
        backgroundColor = .backgroundColor
        subviews.compactMap { $0 as? ColorThemeRefreshable }.forEach { $0.refreshColorTheme() }
    }
}
