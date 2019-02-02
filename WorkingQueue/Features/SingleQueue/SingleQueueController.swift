import UIKit
import Toast_Swift

protocol SingleQueueControllerDelegate: AnyObject {
    func didProceedInWorkflow(currentWorkflowEntry: WorkflowEntry)
    func didReplaceQueueEntry(currentWorkflowEntry: WorkflowEntry)
}

class SingleQueueController: UIViewController {

    weak var delegate: SingleQueueControllerDelegate?

    weak var workflowEntry: WorkflowEntry! {
        didSet {
            queue.initialize(items: workflowEntry.getQueueEntires())
            title = workflowEntry.name
        }
    }

    private lazy var controlBar: ControlBar = {
        let controlBar = ControlBar()
        controlBar.delegate = self
        return controlBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorColor = .separatorColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let cellIdentifier: String
    private var queue: WorkingQueue<QueueEntry>

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        cellIdentifier = "QueueCell"

        var workingQueueOptions = QueueWithSectionsOptions(maximumNumberOfSections: 2)
        workingQueueOptions.setMaximumNumberOfRowsFor(section: 0, to: 1)
        queue = WorkingQueue(options: workingQueueOptions)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        queue.delegate = self

        setupViews()
        setDequeueButtonEditability()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        workflowEntry.setQueueEntries(queue.flattened())
    }

    private func setupViews() {
        view.backgroundColor = .backgroundColor
        tableView.backgroundColor = .backgroundColor

        view.addSubview(controlBar)
        NSLayoutConstraint.activate([
            controlBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlBar.heightAnchor.constraint(equalToConstant: 75)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: controlBar.topAnchor)
        ])
    }

    private func addItem(_ name: String) {
        let isNotEmpty = name.trimmingCharacters(in: .whitespaces).count > 0

        if isNotEmpty {
            queue.enqueue(item: QueueEntry(name: name))
        }
    }

    private func setDequeueButtonEditability() {
        if hasFirstItem() {
            controlBar.enableDequeueButton()
        } else {
            controlBar.disableDequeueButton()
        }
    }

    private func hasFirstItem() -> Bool {
        return queue.numberOfSections > 0
    }
}

extension SingleQueueController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteContextualAction = DeleteContextualAction { [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.queue.remove(section: indexPath.section, row: indexPath.row)
            }
        }

        return UISwipeActionsConfiguration(actions: [deleteContextualAction])
    }
}

extension SingleQueueController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return queue.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.numberOfRowsIn(section: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SingleQueueHeaderLabel(text: section == 0 ? "Next" : "For later")
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = queue.get(section: indexPath.section, row: indexPath.row)?.name
        cell.textLabel?.textColor = .textColor
        cell.backgroundColor = .backgroundColor
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = (sourceIndexPath.section, sourceIndexPath.row)
        let destination = (destinationIndexPath.section, destinationIndexPath.row)
        queue.move(at: source, to: destination)
    }
}

extension SingleQueueController: UITableViewDragDelegate {
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension SingleQueueController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}

    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

extension SingleQueueController: ControlBarDelegate {
    func controlBarDidAdd(_ controlBar: ControlBar) {
        controlBarDidAction(popupBuilder: EnqueuePopupBuilder(delegate: self))
    }

    func controlBarDidDequeue(_ controlBar: ControlBar) {
        if workflowEntry.currentQueueEntry != nil {
            controlBarDidAction(popupBuilder: DequeuePopupBuilder(delegate: self, workflowEntry))
        } else if let item = queue.dequeue() {
            workflowEntry.currentQueueEntry = item
        }
    }

    private func controlBarDidAction(popupBuilder: PopupBuilder) {
        if let controller = popupBuilder.build().getResult() {
            present(controller, animated: true)
        }
    }
}

extension SingleQueueController: EnqueuePopupControllerDelegate {
    func didAcceptWithText(_ text: String) {
        addItem(text)
    }
}

extension SingleQueueController: DequeuePopupControllerDelegate {
    func didProceedInWorkflow() {
        workflowEntry.setQueueEntries(queue.flattened())

        guard let queueEntry = queue.dequeue() else { return }

        makeToast("You have proceeded \"\(queueEntry.name)\" in workflow.")
        delegate?.didProceedInWorkflow(currentWorkflowEntry: workflowEntry)
    }

    func didReplace() {
        workflowEntry.setQueueEntries(queue.flattened())

        guard let queueEntry = queue.dequeue() else { return }

        if let currentItem = workflowEntry.currentQueueEntry {
            queue.enqueue(item: currentItem)
            makeToast("You have replaced \"\(currentItem.name)\" with \"\(queueEntry.name)\".")
        }

        delegate?.didReplaceQueueEntry(currentWorkflowEntry: workflowEntry)
    }
}

extension SingleQueueController: QueueWithSectionsDelegate {
    func didEnqueueAt(section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func didDequeueAt(section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)
        tableView.deleteRows(at: [indexPath], with: .left)
    }

    func didRemoveAt(section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func didMove(at: (section: Int, row: Int), to: (section: Int, row: Int)) {
        let atIndexPath = IndexPath(row: at.row, section: at.section)
        let toIndexPath = IndexPath(row: to.row, section: to.section)
        tableView.moveRow(at: atIndexPath, to: toIndexPath)
    }

    func didAddSection(_ section: Int) {
        tableView.insertSections(IndexSet(integer: section), with: .automatic)
        setDequeueButtonEditability()
    }

    func didRemoveSection(_ section: Int) {
        tableView.deleteSections(IndexSet(integer: section), with: .automatic)
        setDequeueButtonEditability()
    }
}
