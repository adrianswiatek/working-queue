import UIKit

public final class EnqueuePopupBuilder: PopupBuilder {
    private let delegate: EnqueuePopupControllerDelegate
    private var result: EnqueuePopupController?

    public init(delegate: EnqueuePopupControllerDelegate) {
        self.delegate = delegate
    }

    public func build() -> EnqueuePopupBuilder {
        let popupController = EnqueuePopupController()
        popupController.isModalInPopover = true
        popupController.modalPresentationStyle = .overCurrentContext
        popupController.modalTransitionStyle = .crossDissolve
        popupController.delegate = delegate
        result = popupController

        return self
    }

    public func getResult() -> UIViewController? {
        return result
    }
}
