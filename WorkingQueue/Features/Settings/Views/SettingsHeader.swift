import UIKit

public class SettingsHeader: UIView, ColorThemeRefreshable {

    public var headerDidTap: (() -> Void)?

    public var viewModel: SettingsHeaderViewModel? {
        didSet {
            settingNameLabel.text = viewModel?.name
            settingValueLabel.text = viewModel?.value
        }
    }

    private let settingNameLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.font = .systemFont(ofSize: 16)
        label.getTextColor = { UIColor.textColor }
        return label
    }()

    private let settingValueLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.getTextColor = { UIColor.tintColor }
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupGestureRecognizer()
        refreshColorTheme()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupViews() {
        addSubview(settingNameLabel)
        NSLayoutConstraint.activate([
            settingNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            settingNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(settingValueLabel)
        NSLayoutConstraint.activate([
            settingValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            settingValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapGesture() {
        headerDidTap?()
    }

    public func refreshColorTheme() {
        backgroundColor = .backgroundColor
        subviews.compactMap { $0 as? ColorThemeRefreshable }.forEach { $0.refreshColorTheme() }
    }
}
