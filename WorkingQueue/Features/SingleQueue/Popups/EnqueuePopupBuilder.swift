import UIKit

public final class EnqueuePopupBuilder: PopupBuilder {
    private let delegate: EnqueuePopupControllerDelegate
    private var result: EnqueuePopupController?

    required init(delegate: EnqueuePopupControllerDelegate, _ workflowEntry: WorkflowEntry) {
        self.delegate = delegate
    }

    func build() -> EnqueuePopupBuilder {
        let popupController = EnqueuePopupController()
        popupController.isModalInPopover = true
        popupController.modalPresentationStyle = .overCurrentContext
        popupController.modalTransitionStyle = .crossDissolve
        popupController.delegate = delegate
        result = popupController

        return self
    }

    func getResult() -> UIViewController? {
        return result
    }
}
