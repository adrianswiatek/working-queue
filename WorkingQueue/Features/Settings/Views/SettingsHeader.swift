import UIKit

public class SettingsHeader: UIView, ColorThemeRefreshable {

    public var headerDidTap: (() -> Void)?

    public var viewModel: SettingsHeaderViewModel? {
        didSet {
            settingNameLabel.text = viewModel?.name
            settingValueLabel.text = viewModel?.value
            isExpanded = viewModel?.isExpanded == true
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

    private let chevronImageView: ThemedImageView = {
        let imageView = ThemedImageView(image: #imageLiteral(resourceName: "chevron").withRenderingMode(.alwaysTemplate))
        imageView.getTintColor = { UIColor.tintColor }
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupShadows()
        setupViews()
        setupGestureRecognizer()
        refreshColorTheme()
    }

    private var isExpanded: Bool = false {
        didSet {
            if isExpanded != oldValue {
                animateChevron()
            }
        }
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupShadows() {
        layer.shadowOpacity = 0.35
        layer.shadowOffset = .init(width: 0, height: 1)
        layer.shadowColor = UIColor.shadowColor.cgColor
    }

    private func setupViews() {
        addSubview(chevronImageView)
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.heightAnchor.constraint(equalToConstant: 9),
            chevronImageView.widthAnchor.constraint(equalToConstant: 9),
        ])

        addSubview(settingValueLabel)
        NSLayoutConstraint.activate([
            settingValueLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -32),
            settingValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(settingNameLabel)
        NSLayoutConstraint.activate([
            settingNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            settingNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            headerDidTap?()
        }
    }

    private func animateChevron() {
        UIViewPropertyAnimator(duration: 0.33, curve: .easeInOut) {
            self.chevronImageView.transform = self.isExpanded ? .init(rotationAngle: .pi) : .identity
        }.startAnimation()
    }

    public func refreshColorTheme() {
        backgroundColor = .backgroundColor
        subviews.compactMap { $0 as? ColorThemeRefreshable }.forEach { $0.refreshColorTheme() }
    }
}
