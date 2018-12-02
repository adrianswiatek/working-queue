import UIKit

class SingleQueueController: UIViewController {

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
        tableView.separatorColor = UIColor(white: 0.15, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let cellIdentifier: String
    private var queue: WorkingQueue<String>

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        cellIdentifier = "QueueCell"

        var workingQueueOptions = QueueWithSectionsOptions(maximumNumberOfSections: 2)
        workingQueueOptions.setMaximumNumberOfRowsFor(section: 0, to: 1)
        queue = WorkingQueue(options: workingQueueOptions)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        queue.delegate = self

        setupViews()
        setDequeueButtonEditability()

        populateTestData()
    }

    private func setupViews() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        navigationItem.title = "Queue"

        view.addSubview(controlBar)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            controlBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlBar.heightAnchor.constraint(equalToConstant: 75),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: controlBar.topAnchor)
        ])
    }

    private func addItem(_ name: String) {
        let isNotEmpty = name.trimmingCharacters(in: .whitespaces).count > 0

        if isNotEmpty {
            queue.enqueue(item: name)
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

    private func populateTestData() {
        queue.enqueue(item: "1")
        queue.enqueue(item: "2")
        queue.enqueue(item: "3")
        queue.enqueue(item: "4")
        queue.enqueue(item: "5")
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
        cell.textLabel?.text = queue.get(section: indexPath.section, row: indexPath.row)
        cell.textLabel?.textColor = UIColor(white: 1, alpha: 0.7)
        cell.backgroundColor = .black
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
        let popupController = EnqueuePopupBuilder { [unowned self] in self.addItem($0) }
        if let controller = popupController.build().getResult() {
            present(controller, animated: true)
        }
    }

    func controlBarDidDequeue(_ controlBar: ControlBar) {
        queue.dequeue()
    }
}

extension SingleQueueController: QueueWithSectionsDelegate {
    func didEnqueueAt(section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func didDequeueAt(section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
