import UIKit

public class ThemedView: UIView, ColorThemeRefreshable {

    public var getBackgroundColor: (() -> UIColor)?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func refreshColorTheme() {
        backgroundColor = getBackgroundColor?()
    }
}
