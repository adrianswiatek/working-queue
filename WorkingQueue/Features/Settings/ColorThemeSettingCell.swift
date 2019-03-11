import UIKit

public class ColorThemeSettingCell: UICollectionViewCell, ColorThemeRefreshable {

    private let settingNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Color Theme"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let settingValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Light"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        settingNameLabel.textColor = .textColor
        settingValueLabel.textColor = .tintColor
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
            if self.isHighlighted {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95).translatedBy(x: -5, y: 0)
            } else {
                self.transform = .identity
            }
        }
        animator.startAnimation()
    }

    public func setOption(to colorTheme: ColorThemeType) {
        settingValueLabel.text = colorTheme.rawValue
    }
}
