import UIKit

class EnqueuePopupBuilder {

    private let callback: (String) -> Void
    private var result: EnqueuePopupController?

    init(callback: @escaping (String) -> Void) {
        self.callback = callback
    }

    func build() -> EnqueuePopupBuilder {
        let popupController = EnqueuePopupController(callback: callback)
        popupController.isModalInPopover = true
        popupController.modalPresentationStyle = .overCurrentContext
        popupController.modalTransitionStyle = .coverVertical
        result = popupController

        return self
    }

    func getResult() -> UIViewController? {
        return result
    }
}
