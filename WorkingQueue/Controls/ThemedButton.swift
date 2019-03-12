import UIKit

public class ThemedButton: UIButton, ColorThemeRefreshable {

    public var getTintColor: (() -> UIColor)?
    public var getBackgroundColor: (() -> UIColor)?
    public var getBorderColor: (() -> UIColor)?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func refreshColorTheme() {
        tintColor = getTintColor?()
        backgroundColor = getBackgroundColor?()

        layer.borderColor = getBackgroundColor?().cgColor
    }
}
