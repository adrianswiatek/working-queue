import UIKit

public final class DequeuePopupBuilder: PopupBuilder {
    private let delegate: DequeuePopupControllerDelegate
    private let workflowEntry: WorkflowEntry
    private var result: DequeuePopupController?

    required init(delegate: DequeuePopupControllerDelegate, _ workflowEntry: WorkflowEntry) {
        self.delegate = delegate
        self.workflowEntry = workflowEntry
    }

    func build() -> DequeuePopupBuilder {
        let popupController = DequeuePopupController()
        popupController.isModalInPopover = true
        popupController.modalPresentationStyle = .overCurrentContext
        popupController.modalTransitionStyle = .crossDissolve
        popupController.delegate = delegate
        popupController.workflowEntry = workflowEntry
        result = popupController

        return self
    }

    func getResult() -> UIViewController? {
        return result
    }
}
