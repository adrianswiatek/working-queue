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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let cellIdentifier = "QueueCell"
    private var queue = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setDequeueButtonEditability()
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
        guard isNotEmpty else { return }

        var indexPath: IndexPath

        if queue.count == 0 {
            queue.append([String](arrayLiteral: name))
            indexPath = IndexPath(row: 0, section: 0)
        } else if queue.count == 1 {
            queue.append([String](arrayLiteral: name))
            indexPath = IndexPath(row: 0, section: 1)
        } else {
            queue[1].append(name)
            indexPath = IndexPath(row: queue[1].count - 1, section: 1)
        }

        tableView.beginUpdates()

        if tableView.numberOfSections < 2 {
            tableView.insertSections(IndexSet(integer: indexPath.section), with: .automatic)
        }

        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

        setDequeueButtonEditability()
    }

    private func dequeueItem() {
        guard queue.count > 0, queue[0].count == 1 else {
            return
        }

        queue[0].remove(at: 0)
        tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

        moveItemBetweenSectionsAfterDequeue()
        cleanUpSectionsAfterDelete()
        setDequeueButtonEditability()
    }

    private func moveItemBetweenSectionsAfterDequeue() {
        if queue.count == 2, queue[1].count > 0 {
            queue[0].append(queue[1].remove(at: 0))
            tableView.moveRow(at: IndexPath(row: 0, section: 1), to: IndexPath(row: 0, section: 0))
        }
    }

    private func cleanUpSectionsAfterDelete() {
        if queue.count == 2, queue[1].count == 0 {
            queue.remove(at: 1)
            tableView.deleteSections(IndexSet(integer: 1), with: .automatic)
        } else if queue.count == 1, queue[0].count == 0 {
            queue.remove(at: 0)
            tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
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
        return queue.count > 0
    }
}

extension SingleQueueController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteContextualAction = DeleteContextualAction {
            self.queue[indexPath.section].remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.moveItemBetweenSectionsAfterDequeue()

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.cleanUpSectionsAfterDelete()
            }
        }

        return UISwipeActionsConfiguration(actions: [deleteContextualAction])
    }
}

extension SingleQueueController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return queue.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue[section].count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SingleQueueHeaderLabel(text: section == 0 ? "Next" : "For later")
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = queue[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
}

extension SingleQueueController: ControlBarDelegate {
    func controlBarDidAdd(_ controlBar: ControlBar) {
        let popupController = AddSingleQueuePopupBuilder { [unowned self] in self.addItem($0) }

        if let controller = popupController.build().getResult() {
            present(controller, animated: true)
        }
    }

    func controlBarDidDequeue(_ controlBar: ControlBar) {
        dequeueItem()
    }
}
