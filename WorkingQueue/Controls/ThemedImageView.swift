import UIKit

public class ThemedImageView: UIImageView, ColorThemeRefreshable {

    public var getTintColor: (() -> UIColor)?

    public override init(image: UIImage?) {
        super.init(image: image)

        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func refreshColorTheme() {
        tintColor = getTintColor?()
    }
}
