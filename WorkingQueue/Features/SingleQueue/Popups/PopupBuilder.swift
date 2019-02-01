import UIKit

protocol PopupBuilder {
    associatedtype TDelegate

    init(delegate: TDelegate, _ workflowEntry: WorkflowEntry)

    func build() -> Self
    func getResult() -> UIViewController?
}
