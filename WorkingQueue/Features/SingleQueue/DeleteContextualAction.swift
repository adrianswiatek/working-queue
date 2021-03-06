import UIKit

class DeleteContextualAction : UIContextualAction {

    override var style: UIContextualAction.Style {
        return .destructive
    }

    override var handler: UIContextualAction.Handler {
        return { [unowned self] (action, view, handler) in
            handler(true)
            self.callback()
        }
    }

    private let callback: () -> Void

    init(callback: @escaping () -> Void) {
        self.callback = callback

        super.init()
        self.title = "Delete"
        self.backgroundColor = .red
    }
}
