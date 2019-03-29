import UIKit

public class ThemedLabel: UILabel, ColorThemeRefreshable {

    public var getTextColor: (() -> UIColor)?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func refreshColorTheme() {
        textColor = getTextColor?()
    }
}
