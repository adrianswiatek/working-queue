import UIKit

public class ColorThemeSettingCell: UICollectionViewCell, ColorThemeRefreshable {

    private let settingNameLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.text = "Color Theme"
        label.font = .systemFont(ofSize: 16)
        label.getTextColor = { UIColor.textColor }
        return label
    }()

    private let settingValueLabel: ThemedLabel = {
        let label = ThemedLabel()
        label.text = "Light"
        label.font = .boldSystemFont(ofSize: 16)
        label.getTextColor = { UIColor.tintColor }
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
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

    public func refreshColorTheme() {
        backgroundColor = .backgroundColor
        subviews.compactMap { $0 as? ColorThemeRefreshable }.forEach { $0.refreshColorTheme() }
    }

    public override var isHighlighted: Bool {
        didSet {
            handleIsHightlightedChanged()
        }
    }

    private func handleIsHightlightedChanged() {
        let springTimingParameters = UISpringTimingParameters(mass: 1, stiffness: 100, damping: 10, initialVelocity: .zero)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: springTimingParameters)
        animator.addAnimations {
            self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.99) : .identity
        }
        animator.startAnimation()
    }

    public func setOption(to colorTheme: ColorThemeType) {
        settingValueLabel.text = colorTheme.rawValue
    }
}
